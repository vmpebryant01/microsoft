# Inventory Azure load balancers and SKU.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'load_balancers' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
