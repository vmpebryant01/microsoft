# Inventory registered Azure Local edge devices.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'edge_devices' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
