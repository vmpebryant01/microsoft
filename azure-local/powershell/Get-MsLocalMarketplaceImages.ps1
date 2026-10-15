# Inventory Azure Local marketplace gallery images.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'marketplace_images' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
