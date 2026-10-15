# Inventory Azure Local storage containers.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'storage_containers' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
