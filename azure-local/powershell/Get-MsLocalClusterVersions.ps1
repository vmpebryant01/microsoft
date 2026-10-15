# Report Azure Local cluster software and hardware versions.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'cluster_versions' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
