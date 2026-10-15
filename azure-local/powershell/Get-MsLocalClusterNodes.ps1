# Report node entries exposed by cluster resources.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'cluster_nodes' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
