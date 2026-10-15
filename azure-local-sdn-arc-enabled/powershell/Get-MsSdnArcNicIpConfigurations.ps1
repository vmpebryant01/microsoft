# Report Azure Local network interface IP configurations.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'nic_ip_configurations' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
