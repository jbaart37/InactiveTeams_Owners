# InactiveTeams_Owners

This project uses Microsoft Graph to report inactive Microsoft Teams and their owners. The script identifies teams that have been inactive for a specified number of days and outputs the details to a CSV file.

## Prerequisites

- PowerShell 5.1 or later
- Microsoft.Graph PowerShell module

## Installation

1. Ensure you have PowerShell 5.1 or later installed.
2. Install the Microsoft.Graph module if not already installed:
    ```powershell
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
    ```

## Usage

1. Open PowerShell and navigate to the directory containing the [inactive.ps1](http://_vscodecontentref_/1) script.
2. Run the script:
    ```powershell
    .\inactive.ps1
    ```

## Script Details

The script performs the following actions:

1. Connects to Microsoft Graph with the required scopes.
2. Iterates through the list of teams and checks the last activity date for each team's channels.
3. If a team has been inactive for more than the specified threshold days, it retrieves the team's owners.
4. Outputs the details of inactive teams and their owners to the console and a CSV file (`inactive_teams.csv`).

## Output

The script generates a CSV file (`inactive_teams.csv`) with the following columns:

- `TeamName`: The name of the inactive team.
- `LastActivityDate`: The date of the last activity in the team.
- `OwnerUPN`: The User Principal Name of the team owner.
- `OwnerDisplayName`: The display name of the team owner.

## Example Output

```csv
"TeamName","LastActivityDate","OwnerUPN","OwnerDisplayName"
"Mark 8 Project Team","6/28/2024 2:25:51 PM","user1@yourdomain.com","MOD Administrator"
"Mark 8 Project Team","6/28/2024 2:25:51 PM","Jane@yourdomain.com","Jane Jones"
...
