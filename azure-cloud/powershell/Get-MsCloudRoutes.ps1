# Report routes embedded in Azure route tables.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'routes' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
