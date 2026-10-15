# Report cluster update summaries.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'update_summaries' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
