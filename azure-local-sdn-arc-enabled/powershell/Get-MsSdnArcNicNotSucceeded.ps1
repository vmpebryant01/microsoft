# Find Azure Local interfaces without a Succeeded provisioning state.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nic_not_succeeded' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
