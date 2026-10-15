# Inventory cluster Arc settings.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'arc_settings' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
