# Report logical network subnets and DNS settings.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'logical_network_addressing' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
