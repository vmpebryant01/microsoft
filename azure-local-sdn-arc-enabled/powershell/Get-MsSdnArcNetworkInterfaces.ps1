# Inventory Azure Local network interfaces projected into Azure.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'network_interfaces' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
