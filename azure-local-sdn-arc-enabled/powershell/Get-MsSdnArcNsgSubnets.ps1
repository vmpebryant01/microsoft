# Report logical network subnets associated with NSGs.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nsg_subnets' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
