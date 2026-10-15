# Inventory Azure Local gallery images.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'gallery_images' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
