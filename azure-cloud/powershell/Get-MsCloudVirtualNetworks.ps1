# Inventory Azure virtual networks and address spaces.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'virtual_networks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
