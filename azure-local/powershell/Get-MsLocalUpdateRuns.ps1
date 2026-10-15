# Report Azure Local cluster update runs.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'update_runs' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
