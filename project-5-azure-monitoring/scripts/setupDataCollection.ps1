# setupDataCollection.ps1
# Description: Links a VM to a Log Analytics workspace by installing the Log Analytics agent.
# Replace the parameter defaults with your actual resource group, workspace, and VM name.

param(
    [string]$ResourceGroupName = "MyResourceGroup",
    [string]$WorkspaceName = "MyLogAnalyticsWorkspace",
    [string]$VMName = "MyVM"
)

# Login to Azure
Connect-AzAccount

# Retrieve the Log Analytics workspace details
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroupName -Name $WorkspaceName

# Retrieve the virtual machine details
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName

# Install the Log Analytics agent on the VM (for Windows; adjust for Linux if needed)
Set-AzVMExtension -ResourceGroupName $ResourceGroupName `
  -VMName $VMName `
  -Name "LogAnalyticsAgent" `
  -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
  -ExtensionType "MicrosoftMonitoringAgent" `
  -TypeHandlerVersion "1.0" `
  -Settings @{ "workspaceId" = $workspace.CustomerId } `
  -ProtectedSettings @{ "workspaceKey" = (Get-AzOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $ResourceGroupName -Name $WorkspaceName).PrimarySharedKey }

Write-Output "Data collection agent installed on VM '$VMName' and linked to workspace '$WorkspaceName'."
