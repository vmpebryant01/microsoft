# Report subnet definitions within Azure Local logical networks.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'logical_network_subnets' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
