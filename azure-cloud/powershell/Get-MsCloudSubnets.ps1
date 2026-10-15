# Report embedded subnet definitions in virtual networks.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'subnets' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
