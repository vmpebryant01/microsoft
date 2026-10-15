# Inventory availability sets and fault domain settings.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'availability_sets' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
