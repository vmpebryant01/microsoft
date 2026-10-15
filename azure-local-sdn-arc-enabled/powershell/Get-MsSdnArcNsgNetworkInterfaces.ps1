# Report interfaces associated with Azure Local NSGs.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nsg_network_interfaces' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
