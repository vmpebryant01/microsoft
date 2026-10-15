# Report security group references on Azure Local interfaces.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nic_security_groups' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
