# Read-only reporting for Azure Resource Graph and Network Controller.
# Author: Paul Bryant

Set-StrictMode -Version Latest

function Get-ReportDefinition {
    param([string]$Category, [string]$ReportId)
    $path = Join-Path (Split-Path -Parent $PSScriptRoot) "$Category/reports.json"
    $catalog = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -AsHashtable
    $report = @($catalog.reports | Where-Object { $_.id -eq $ReportId })
    if ($report.Count -ne 1) { throw "Unknown report: $ReportId" }
    return @{ Catalog = $catalog; Report = $report[0] }
}

function Get-PathValue {
    param($Value, [string]$Path)
    if (-not $Path) { return ,$Value }
    foreach ($part in $Path.Split('.')) {
        if ($null -eq $Value -or $Value -isnot [System.Collections.IDictionary]) { return $null }
        $Value = $Value[$part]
    }
    return ,$Value
}

function Get-FieldValue {
    param($Resource, $Item, [string]$Path)
    if ($Path -eq 'parentId') { return $Resource._parentId }
    if ($Path -eq 'item') { return ,$Item }
    if ($Path.StartsWith('item.')) { return Get-PathValue $Item $Path.Substring(5) }
    return Get-PathValue $Resource $Path
}

function Test-ReportFilter {
    param($Value, $Condition)
    if (-not $Condition) { return $true }
    $values = if ($Value -is [array]) { $Value } else { @($Value) }
    switch ($Condition.op) {
        'present' { return [bool](@($values | Where-Object { $null -ne $_ -and "$_" -ne '' }).Count) }
        'missing' { return -not [bool](@($values | Where-Object { $null -ne $_ -and "$_" -ne '' }).Count) }
        'eq' { return [bool](@($values | Where-Object { "$_" -ieq "$($Condition.value)" }).Count) }
        'ne' { return -not [bool](@($values | Where-Object { "$_" -ieq "$($Condition.value)" }).Count) }
        'contains' { return [bool](@($values | Where-Object { "$_".ToLowerInvariant().Contains("$($Condition.value)".ToLowerInvariant()) }).Count) }
        default { throw "Unsupported report filter: $($Condition.op)" }
    }
}

function ConvertTo-ReportRows {
    param([array]$Resources, $Report)
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($resource in $Resources) {
        if ($Report.ContainsKey('expand')) {
            $items = Get-PathValue $resource $Report.expand
            if ($null -eq $items) { continue }
        } else {
            $items = ,$null
        }
        foreach ($item in @($items)) {
            if ($Report.ContainsKey('filter')) {
                $value = Get-FieldValue $resource $item $Report.filter.path
                if (-not (Test-ReportFilter $value $Report.filter)) { continue }
            }
            $row = [ordered]@{}
            foreach ($field in $Report.fields) {
                $row[$field[0]] = Get-FieldValue $resource $item $field[1]
            }
            $rows.Add([pscustomobject]$row)
        }
    }
    return ,$rows.ToArray()
}

function Assert-CustomLocationId {
    param([string]$CustomLocation)
    $target = $CustomLocation.Trim().TrimEnd('/')
    if ($target -notmatch '^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\.ExtendedLocation/customLocations/[^/]+$') {
        throw 'A full Azure custom location resource ID is required'
    }
    return $target
}

function Select-CustomLocationResources {
    param([array]$Resources, [string]$CustomLocation)
    $target = Assert-CustomLocationId $CustomLocation
    $selected = [System.Collections.Generic.List[object]]::new()
    foreach ($resource in $Resources) {
        $location = Get-PathValue $resource 'extendedLocation.name'
        if ($location -is [string] -and $location.TrimEnd('/') -ieq $target) {
            $selected.Add($resource)
        }
    }
    return ,$selected.ToArray()
}

function Test-ArgResultTruncated {
    param($Value)
    if ($null -eq $Value) { return $false }
    if ($Value -is [bool]) { return $Value }
    $text = "$Value"
    if ($text -ieq 'true') { return $true }
    if ($text -ieq 'false') { return $false }
    throw 'Azure Resource Graph returned an unexpected ResultTruncated value'
}

function Get-ArgResources {
    param([string]$ResourceType, [string[]]$SubscriptionId)
    if (-not $SubscriptionId -or $SubscriptionId.Count -eq 0) { throw 'At least one SubscriptionId is required' }
    if (-not (Get-Command Search-AzGraph -ErrorAction SilentlyContinue)) {
        throw 'Az.ResourceGraph is required. Install it and sign in with Connect-AzAccount.'
    }
    $query = "Resources | where type =~ '$ResourceType' | order by id asc"
    $resources = [System.Collections.Generic.List[object]]::new()
    $skipToken = $null
    do {
        $options = @{ Query = $query; Subscription = $SubscriptionId; First = 1000; ErrorAction = 'Stop' }
        if ($skipToken) { $options.SkipToken = $skipToken }
        $page = Search-AzGraph @options
        if ($null -ne $page.Data) {
            foreach ($item in @($page.Data)) {
                $resources.Add(($item | ConvertTo-Json -Depth 100 -Compress | ConvertFrom-Json -AsHashtable))
            }
        }
        $skipToken = $page.SkipToken
        if (-not $skipToken -and $page.PSObject.Properties['ResultTruncated'] -and (Test-ArgResultTruncated $page.ResultTruncated)) {
            throw 'Azure Resource Graph truncated results without a continuation token'
        }
    } while ($skipToken)
    return ,$resources.ToArray()
}

function ConvertTo-NcItems {
    param($Payload)
    if ($Payload -is [array]) { return ,$Payload }
    if ($Payload -is [System.Collections.IDictionary]) {
        foreach ($key in @('value', 'Value', 'resources', 'Resources')) {
            if ($Payload[$key] -is [array]) { return ,$Payload[$key] }
        }
        if ($Payload.resourceId -or $Payload.id) { return ,$Payload }
    }
    throw 'Network Controller returned an unexpected collection shape'
}

function ConvertTo-HashPayload {
    param($Payload)
    return ,(ConvertFrom-Json -InputObject (ConvertTo-Json -InputObject $Payload -Depth 100 -Compress) -AsHashtable -NoEnumerate)
}

function Get-NcResources {
    param($Report, [string]$ControllerUri)
    if (-not $ControllerUri.StartsWith('https://')) { throw 'ControllerUri must use HTTPS' }
    $base = $ControllerUri.TrimEnd('/')
    $root = "$base/networking/v1/$($Report.source)"
    $payload = Invoke-RestMethod -Method Get -Uri $root -UseDefaultCredentials -TimeoutSec 30 -ErrorAction Stop
    $parents = ConvertTo-NcItems (ConvertTo-HashPayload $payload)
    if (-not $Report.ContainsKey('child')) { return ,$parents }
    $children = [System.Collections.Generic.List[object]]::new()
    foreach ($parent in $parents) {
        $parentId = if ($parent.resourceId) { "$($parent.resourceId)" } else { "$($parent.id)" }
        if (-not $parentId) { throw 'Network Controller parent resource has no ID' }
        $parentId = $parentId.TrimEnd('/').Split('/')[-1]
        $encoded = [uri]::EscapeDataString($parentId)
        $uri = "$root/$encoded/$($Report.child)"
        $payload = Invoke-RestMethod -Method Get -Uri $uri -UseDefaultCredentials -TimeoutSec 30 -ErrorAction Stop
        $items = ConvertTo-NcItems (ConvertTo-HashPayload $payload)
        foreach ($item in $items) {
            $item['_parentId'] = $parentId
            $children.Add($item)
        }
    }
    return ,$children.ToArray()
}

function ConvertTo-SafeCsvValue {
    param($Value)
    if ($null -eq $Value) { return '' }
    $text = if ($Value -is [array] -or $Value -is [System.Collections.IDictionary]) {
        ConvertTo-Json -InputObject $Value -Depth 100 -Compress
    } else { "$Value" }
    if ($Value -is [string] -and $text.TrimStart() -match '^[=+\-@]') { return "'$text" }
    return $text
}

function Invoke-Report {
    param(
        [Parameter(Mandatory)][string]$Category,
        [Parameter(Mandatory)][string]$ReportId,
        [string[]]$SubscriptionId,
        [string]$ControllerUri,
        [string]$CustomLocation,
        [string]$OutputPath,
        [switch]$Describe
    )
    $definition = Get-ReportDefinition $Category $ReportId
    $report = $definition.Report
    if ($Describe) { return [pscustomobject]$report }
    if ($Category -eq 'azure-local-sdn-arc-enabled' -and -not $CustomLocation) {
        throw 'CustomLocation is required for Arc-enabled SDN reports'
    }
    if ($Category -eq 'azure-local-sdn-arc-enabled') {
        Assert-CustomLocationId $CustomLocation | Out-Null
    }
    $resources = if ($definition.Catalog.source -eq 'arg') {
        Get-ArgResources $report.source_type $SubscriptionId
    } else {
        if (-not $ControllerUri) { throw 'ControllerUri is required' }
        Get-NcResources $report $ControllerUri
    }
    if ($Category -eq 'azure-local-sdn-arc-enabled') {
        $resources = Select-CustomLocationResources @($resources) $CustomLocation
    }
    $rows = ConvertTo-ReportRows @($resources) $report
    if (-not $OutputPath) { return $rows }
    $columns = @($report.fields | ForEach-Object { $_[0] })
    $safeRows = foreach ($row in $rows) {
        $safe = [ordered]@{}
        foreach ($column in $columns) { $safe[$column] = ConvertTo-SafeCsvValue $row.$column }
        [pscustomobject]$safe
    }
    if (@($safeRows).Count -eq 0) {
        $header = ($columns | ForEach-Object { '"' + $_.Replace('"', '""') + '"' }) -join ','
        Set-Content -LiteralPath $OutputPath -Value $header -Encoding utf8
    } else {
        $safeRows | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding utf8
    }
}
