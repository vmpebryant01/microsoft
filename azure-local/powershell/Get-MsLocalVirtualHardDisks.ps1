# Inventory Azure Local virtual hard disks.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'virtual_hard_disks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
