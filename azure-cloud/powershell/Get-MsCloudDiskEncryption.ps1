# Report managed disk encryption settings.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'disk_encryption' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
