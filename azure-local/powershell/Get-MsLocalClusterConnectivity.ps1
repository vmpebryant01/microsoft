# Report registration and connectivity fields for clusters.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'cluster_connectivity' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
