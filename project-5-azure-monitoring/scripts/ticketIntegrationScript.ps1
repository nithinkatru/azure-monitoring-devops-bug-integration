# TicketIntegration_Debug.ps1
param(
    [string]$OrgUrl = "https://dev.azure.com/akhilmano1",
    [string]$Project = "AZurearm",
    [string]$PersonalAccessToken = "COhePKnZcEl9i3aToEPUff8apT9YB8InSLaxBVkn1dwVFEccNvBlJQQJ99BDACAAAAAAAAAAAAASAZDO1HHz",
    [string]$AlertTitle = "Alert: High CPU Usage",
    [string]$AlertDescription = "CPU usage has exceeded the threshold on one or more virtual machines."
)

Write-Output "Starting Ticket Integration Debug Script..."
Write-Output "Organization URL: $OrgUrl"
Write-Output "Project: $Project"

# Encode the PAT – note we intentionally escape the colon before the PAT value.
try {
    $encodedPAT = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PersonalAccessToken"))
    Write-Output "PAT encoded successfully."
} catch {
    Write-Error "Error encoding PAT: $_"
    exit 1
}

# Construct the URL
# Use a backtick (`` ` ``) to escape the literal $ sign for Bug.
$uri = "$OrgUrl/$Project/_apis/wit/workitems/`$Bug?api-version=6.0"
Write-Output "Constructed URI: $uri"

# Build the JSON body
$bodyContent = @(
    @{ op = "add"; path = "/fields/System.Title"; value = $AlertTitle },
    @{ op = "add"; path = "/fields/System.Description"; value = $AlertDescription }
)
try {
    $body = $bodyContent | ConvertTo-Json -Depth 5
    Write-Output "Converted body to JSON."
    Write-Debug "JSON Body: $body" -Debug
} catch {
    Write-Error "Error converting body to JSON: $_"
    exit 1
}

# Invoke the REST method with extra debugging and error handling
try {
    Write-Output "Sending POST request to Azure DevOps API..."
    $response = Invoke-RestMethod -Method Post -Uri $uri `
        -Headers @{ Authorization = "Basic $encodedPAT" } `
        -ContentType "application/json-patch+json" `
        -Body $body -Verbose
    Write-Output "POST request successful."
    if ($response -and $response.id) {
        Write-Output "Work item created with ID: $($response.id)"
    }
    else {
        Write-Warning "Response did not contain an ID:"
        Write-Output $response
    }
} catch {
    Write-Error "Error during Invoke-RestMethod: $_"
}
