param(
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$targetVersion = [version]'42.20.0'
$directoryTargets = [System.Collections.Generic.List[string]]::new()
$fileTargets = [System.Collections.Generic.List[string]]::new()

function Add-SafeDirectoryTarget {
    param([string]$Path)
    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $repoRoot.TrimEnd('\') + '\'
    if (-not $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Directorio fuera del repositorio: $full"
    }
    if ($full -eq $repoRoot -or -not (Test-Path -LiteralPath $full -PathType Container)) {
        throw "Directorio no válido: $full"
    }
    if (-not $directoryTargets.Contains($full)) {
        $directoryTargets.Add($full)
    }
}

function Add-SafeFileTarget {
    param([string]$Path)
    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $repoRoot.TrimEnd('\') + '\'
    if (-not $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Archivo fuera del repositorio: $full"
    }
    if (Test-Path -LiteralPath $full -PathType Leaf) {
        $fileTargets.Add($full)
    }
}

$modRoots = Get-ChildItem -LiteralPath $repoRoot -Recurse -Directory -Filter mods |
    Where-Object { $_.Parent.Name -eq 'Contents' } |
    ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Directory }

foreach ($modRoot in $modRoots) {
    $versionFolders = Get-ChildItem -LiteralPath $modRoot.FullName -Directory |
        Where-Object { $_.Name -match '^\d+(?:\.\d+)*$' } |
        ForEach-Object {
            $versionText = $_.Name
            if ($versionText -notmatch '\.') {
                $versionText += '.0'
            }
            [PSCustomObject]@{
                Directory = $_
                Version = [version]$versionText
            }
        } |
        Where-Object { $_.Version -le $targetVersion } |
        Sort-Object Version

    if ($versionFolders.Count -gt 1) {
        $keep = $versionFolders[-1].Directory.FullName
        foreach ($entry in $versionFolders) {
            if ($entry.Directory.FullName -ne $keep) {
                Add-SafeDirectoryTarget $entry.Directory.FullName
            }
        }
    }

    $hasModernLayer = (Test-Path -LiteralPath (Join-Path $modRoot.FullName 'common')) -or $versionFolders.Count
    if ($hasModernLayer) {
        foreach ($legacyName in ('media', 'Resources')) {
            $legacy = Join-Path $modRoot.FullName $legacyName
            if (Test-Path -LiteralPath $legacy -PathType Container) {
                Add-SafeDirectoryTarget $legacy
            }
        }
    }
}

# Tile packs retained as separate compatibility IDs but without duplicate payload.
$aliasPayloads = @(
    'EclipseZ - 1\Contents\mods\ECZ_T1\common',
    'EclipseZ - 1\Contents\mods\ECZ_T2\common',
    'EclipseZ - 1\Contents\mods\ECZ_8.5\common',
    'EclipseZ - 1\Contents\mods\ECZ_8.3\common'
)
foreach ($relative in $aliasPayloads) {
    $path = Join-Path $repoRoot $relative
    if (Test-Path -LiteralPath $path -PathType Container) {
        Add-SafeDirectoryTarget $path
    }
}

# Redundant common-layer metadata and development-only artifacts.
foreach ($relative in @(
    'EclipseZ - 1\Contents\mods\ECZ_8.4\common\mod.info',
    'EclipseZ - 1\Contents\mods\ECZ_8.4\common\icon.png',
    'EclipseZ - 1\Contents\mods\ECZ_8.4\common\poster.png'
)) {
    Add-SafeFileTarget (Join-Path $repoRoot $relative)
}

Get-ChildItem -LiteralPath $repoRoot -Recurse -File | Where-Object {
    $_.Extension -in @('.psd', '.bak') -or
    $_.Name -like "*.incompatibleGun'sElevatormod" -or
    $_.Name -like '*.txt(needfix)'
} | ForEach-Object {
    Add-SafeFileTarget $_.FullName
}

$standaloneTargets = [System.Collections.Generic.List[string]]::new()
foreach ($file in $fileTargets) {
    $insideRemovedDirectory = $false
    foreach ($directory in $directoryTargets) {
        if ($file.StartsWith($directory.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
            $insideRemovedDirectory = $true
            break
        }
    }
    if (-not $insideRemovedDirectory) {
        $standaloneTargets.Add($file)
    }
}
$fileTargets = $standaloneTargets

$directoryBytes = 0L
$directoryFiles = 0
foreach ($target in $directoryTargets) {
    $files = Get-ChildItem -LiteralPath $target -Recurse -File -ErrorAction Stop
    $directoryFiles += $files.Count
    $directoryBytes += [long](($files | Measure-Object Length -Sum).Sum)
}
$fileBytes = [long](($fileTargets | Get-Item | Measure-Object Length -Sum).Sum)

$summary = [ordered]@{
    target = 'Project Zomboid 42.20.0'
    applied = [bool]$Apply
    directories = $directoryTargets.Count
    standaloneFiles = $fileTargets.Count
    filesRemoved = $directoryFiles + $fileTargets.Count
    bytesRemoved = $directoryBytes + $fileBytes
    gibRemoved = [math]::Round(($directoryBytes + $fileBytes) / 1GB, 3)
    directoryTargets = @($directoryTargets | ForEach-Object { $_.Substring($repoRoot.Length + 1) })
    fileTargets = @($fileTargets | ForEach-Object { $_.Substring($repoRoot.Length + 1) })
}

if ($Apply) {
    foreach ($target in $directoryTargets) {
        $resolved = [IO.Path]::GetFullPath($target)
        if (-not $resolved.StartsWith($repoRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
            throw "La validación final ha fallado: $resolved"
        }
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
    foreach ($target in $fileTargets) {
        $resolved = [IO.Path]::GetFullPath($target)
        if (-not $resolved.StartsWith($repoRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
            throw "La validación final ha fallado: $resolved"
        }
        Remove-Item -LiteralPath $resolved -Force
    }
}

$reportName = if ($Apply) {
    'optimization-prune-report.json'
} else {
    'optimization-prune-preview.json'
}
$reportPath = Join-Path $repoRoot (Join-Path 'docs' $reportName)
[IO.Directory]::CreateDirectory((Split-Path -Parent $reportPath)) | Out-Null
[IO.File]::WriteAllText(
    $reportPath,
    (($summary | ConvertTo-Json -Depth 6) + [Environment]::NewLine),
    [Text.UTF8Encoding]::new($false)
)
$summary | ConvertTo-Json -Depth 3
