# Report tenant virtual gateway network connections.
# Author: Paul Bryant
param([string]$ControllerUri, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-onprem' -ReportId 'gateway_connections' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe
