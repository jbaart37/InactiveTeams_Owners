$inactiveTeams = @()
$currentDate = Get-Date
$thresholdDays = 60

# Ensure the Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

# Connect to Microsoft Graph with the required scopes
Connect-MgGraph -Scopes "Group.Read.All, ChannelMessage.Read.All, User.Read.All"

foreach ($team in $teams) {
    $channels = Get-MgTeamChannel -TeamId $team.GroupId
    $lastActivityDate = $null

    foreach ($channel in $channels) {
        $messages = Get-MgTeamChannelMessage -TeamId $team.GroupId -ChannelId $channel.Id
        if ($messages) {
            $lastMessage = $messages | Sort-Object CreatedDateTime -Descending | Select-Object -First 1
            if ($lastMessage) {
                $lastActivityDate = $lastMessage.CreatedDateTime
                break
            }
        }
    }

    if ($lastActivityDate -and (($currentDate - $lastActivityDate).Days -ge $thresholdDays)) {
        $ownerIds = Get-MgGroupOwner -GroupId $team.GroupId | Select-Object -ExpandProperty Id
        foreach ($ownerId in $ownerIds) {
            $owner = Get-MgUser -UserId $ownerId | Select-Object UserPrincipalName, DisplayName
            $inactiveTeams += [PSCustomObject]@{
                TeamName = $team.DisplayName
                LastActivityDate = $lastActivityDate
                OwnerUPN = $owner.UserPrincipalName
                OwnerDisplayName = $owner.DisplayName
            }
        }
    }
}

# Output to screen
$inactiveTeams | ForEach-Object {
    Write-Output "Team: $($_.TeamName)"
    Write-Output "Last Activity Date: $($_.LastActivityDate)"
    Write-Output "Owner UPN: $($_.OwnerUPN)"
    Write-Output "Owner DisplayName: $($_.OwnerDisplayName)"
    Write-Output ""
}

# Output to CSV
$inactiveTeams | Export-Csv -Path "inactive_teams.csv" -NoTypeInformation