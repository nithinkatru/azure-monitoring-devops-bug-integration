# testAlert.ps1
# Description: This script demonstrates how you might test an alert by executing a Log Analytics query.
# Replace <Your-Workspace-Id> and <Your_Access_Token> with your actual values if you enable authenticated REST queries.

param(
    [string]$WorkspaceId = "<Your-Workspace-Id>",
    [string]$Query = "Perf | where ObjectName == 'Processor' and CounterName == '% Processor Time' | summarize AvgCPU=avg(CounterValue) by Computer | where AvgCPU > 80",
    [string]$ApiVersion = "v1"
)

# Build the query URI (URL-encoded)
$uri = "https://api.loganalytics.io/$ApiVersion/workspaces/$WorkspaceId/query?query=$([System.Web.HttpUtility]::UrlEncode($Query))"

Write-Output "Simulating alert query using URI:"
Write-Output $uri

# Uncomment and configure the following if you have an access token for authentication.
# $result = Invoke-RestMethod -Method Get -Uri $uri -Headers @{ Authorization = "Bearer <Your_Access_Token>" }
# Write-Output "Query result:" $result
