# Offline checks for the PowerShell report entry points.
# Author: Paul Bryant

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $root '_shared/ReportEngine.ps1')

$scripts = @(Get-ChildItem -LiteralPath $root -Recurse -Filter '*.ps1' | Where-Object { $_.DirectoryName -match '[\\/](powershell)$' })
if ($scripts.Count -ne 100) { throw "Expected 100 PowerShell reports, found $($scripts.Count)" }
foreach ($script in $scripts) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count) { throw "PowerShell parse error in $($script.FullName): $($errors[0])" }
    $description = & $script.FullName -Describe
    if (-not $description.id) { throw "PowerShell description failed in $($script.FullName)" }
}

$sample = Join-Path $root 'azure-cloud/powershell/Get-MsCloudVmInventory.ps1'
$description = & $sample -Describe
if ($description.id -ne 'vm_inventory') { throw 'PowerShell report description failed' }

$report = @{
    expand = 'properties.securityRules'
    filter = @{ path = 'item.properties.access'; op = 'eq'; value = 'Deny' }
    fields = @(@('nsg', 'name'), @('rule', 'item.name'))
}
$resources = @(@{ name = 'nsg-one'; properties = @{ securityRules = @(
    @{ name = 'allow'; properties = @{ access = 'Allow' } },
    @{ name = 'deny'; properties = @{ access = 'Deny' } }
) } })
$rows = @(ConvertTo-ReportRows $resources $report)
if ($rows.Count -ne 1 -or $rows[0].rule -ne 'deny') { throw 'PowerShell report projection failed' }

$plainReport = @{ fields = @() }
$plainReport.fields += ,@('name', 'name')
$plainRows = @(ConvertTo-ReportRows @(@{ name = 'vm-one' }) $plainReport)
if ($plainRows.Count -ne 1 -or $plainRows[0].name -ne 'vm-one') {
    throw 'PowerShell non-expanded report projection failed'
}
$fixture = Get-Content -LiteralPath (Join-Path $root 'tests/fixtures/report_cases.json') -Raw | ConvertFrom-Json -AsHashtable
foreach ($case in $fixture.cases) {
    $definition = Get-ReportDefinition $case.category $case.report
    $fixtureResources = @($case.resources)
    if ($case.ContainsKey('custom_location')) {
        $fixtureResources = Select-CustomLocationResources $fixtureResources $case.custom_location
    }
    $fixtureRows = @(ConvertTo-ReportRows $fixtureResources $definition.Report)
    if ($fixtureRows.Count -ne @($case.expected).Count) { throw "Fixture row count failed: $($case.category)/$($case.report)" }
    for ($index = 0; $index -lt $fixtureRows.Count; $index++) {
        foreach ($key in $case.expected[$index].Keys) {
            $actual = ConvertTo-Json -InputObject $fixtureRows[$index].$key -Depth 100 -Compress
            $expected = ConvertTo-Json -InputObject $case.expected[$index][$key] -Depth 100 -Compress
            if ($actual -cne $expected) { throw "Fixture value failed: $($case.category)/$($case.report)/$key" }
        }
    }
}
if (-not (Test-ArgResultTruncated 'true')) { throw 'String truncation flag was not recognized' }
if (Test-ArgResultTruncated 'false') { throw 'String false truncation flag was not recognized' }
try {
    Test-ArgResultTruncated 'unknown' | Out-Null
    throw 'Unexpected truncation flag was accepted'
} catch {
    if ($_.Exception.Message -eq 'Unexpected truncation flag was accepted') { throw }
}

$emptyNetworkController = ConvertTo-NcItems (ConvertTo-HashPayload @())
if (@($emptyNetworkController).Count -ne 0) { throw 'Empty Network Controller response failed' }
$emptyRows = ConvertTo-ReportRows @() $report
if (@($emptyRows).Count -ne 0) { throw 'Empty report projection failed' }
if ((ConvertTo-SafeCsvValue (-1)) -ne '-1') { throw 'Negative number CSV conversion failed' }

$global:graphData = @()
$global:graphTruncated = 'false'
function Search-AzGraph {
    param($Query, $Subscription, $First, $ErrorAction)
    return [pscustomobject]@{ Data = $global:graphData; SkipToken = $null; ResultTruncated = $global:graphTruncated }
}
$emptyAzure = Get-ArgResources 'microsoft.compute/virtualmachines' @('test-subscription')
if (@($emptyAzure).Count -ne 0) { throw 'Empty Azure Resource Graph response failed' }
$emptyReport = @(& $sample -SubscriptionId 'test-subscription')
if ($emptyReport.Count -ne 0) { throw 'Empty PowerShell entry point emitted a row' }
$global:graphData = @([pscustomobject]@{ id = 'vm-id'; name = 'vm-one'; resourceGroup = 'rg-one'; subscriptionId = 'test-subscription'; location = 'eastus'; properties = @{ hardwareProfile = @{ vmSize = 'Standard_B2s' }; provisioningState = 'Succeeded' } })
$actualReport = @(& $sample -SubscriptionId 'test-subscription')
if ($actualReport.Count -ne 1 -or $actualReport[0].name -ne 'vm-one' -or $actualReport[0].vmSize -ne 'Standard_B2s') {
    throw 'PowerShell entry point did not project its catalog report'
}
$arcSample = Join-Path $root 'azure-local-sdn-arc-enabled/powershell/Get-MsSdnArcLogicalNetworks.ps1'
$targetLocation = '/subscriptions/example/resourceGroups/sample/providers/Microsoft.ExtendedLocation/customLocations/one'
$global:graphData = @(
    [pscustomobject]@{ name = 'one'; extendedLocation = @{ name = $targetLocation } },
    [pscustomobject]@{ name = 'two'; extendedLocation = @{ name = $targetLocation.Replace('/one', '/two') } }
)
$scopedReport = @(& $arcSample -SubscriptionId 'test-subscription' -CustomLocation $targetLocation)
if ($scopedReport.Count -ne 1 -or $scopedReport[0].name -ne 'one') {
    throw 'Arc entry point did not apply custom location scope'
}
try {
    & $arcSample -SubscriptionId 'test-subscription' | Out-Null
    throw 'Arc entry point accepted a missing custom location'
} catch {
    if ($_.Exception.Message -eq 'Arc entry point accepted a missing custom location') { throw }
}
$global:graphTruncated = 'true'
try {
    & $sample -SubscriptionId 'test-subscription' | Out-Null
    throw 'Truncated PowerShell report was accepted'
} catch {
    if ($_.Exception.Message -eq 'Truncated PowerShell report was accepted') { throw }
}

Write-Output 'PowerShell report checks passed.'
