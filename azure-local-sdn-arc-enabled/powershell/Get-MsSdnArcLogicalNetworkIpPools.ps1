# Report IP pools by Azure Local logical network subnet.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'logical_network_ip_pools' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
