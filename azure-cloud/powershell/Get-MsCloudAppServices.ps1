# Inventory App Service applications and runtime state.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'app_services' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
