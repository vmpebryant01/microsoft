# Report load balancer outbound NAT rules.
# Author: Paul Bryant
param([string]$ControllerUri, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-onprem' -ReportId 'lb_outbound_nat' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe
