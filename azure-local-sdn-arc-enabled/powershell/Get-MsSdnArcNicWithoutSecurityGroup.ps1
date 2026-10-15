# Find Azure Local interfaces without an NSG reference.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$CustomLocation, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nic_without_security_group' -SubscriptionId $SubscriptionId -CustomLocation $CustomLocation -OutputPath $OutputPath -Describe:$Describe
