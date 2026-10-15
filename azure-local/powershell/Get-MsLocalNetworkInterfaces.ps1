# Inventory Azure Local network interfaces.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'network_interfaces' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
