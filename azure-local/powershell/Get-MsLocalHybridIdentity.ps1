# Inventory Azure Local VM hybrid identity metadata.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'hybrid_identity' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
