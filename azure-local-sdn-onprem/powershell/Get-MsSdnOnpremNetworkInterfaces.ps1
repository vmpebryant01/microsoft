# Inventory Network Controller network interfaces.
# Author: Paul Bryant
param([string]$ControllerUri, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-onprem' -ReportId 'network_interfaces' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe
