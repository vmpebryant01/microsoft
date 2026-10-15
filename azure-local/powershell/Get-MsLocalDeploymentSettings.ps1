# Inventory Azure Local deployment settings resources.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'deployment_settings' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
