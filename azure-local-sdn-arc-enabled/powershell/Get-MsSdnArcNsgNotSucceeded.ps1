# Find Azure Local NSGs without a Succeeded provisioning state.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nsg_not_succeeded' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
