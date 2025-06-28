param(
    [switch]$Force,
    [switch]$Quiet,
    [switch]$Debug,
    [string]$DotfilesWindowsRoot
)

if (-not [string]::IsNullOrEmpty($DotfilesWindowsRoot)) {
    $ScriptRoot = $DotfilesWindowsRoot
} elseif ($env:HOME) {
    $ScriptRoot = Join-Path $env:HOME ".dotfiles\windows"
} elseif ($PSScriptRoot) {
    $ScriptRoot = $PSScriptRoot
} else {
    $ScriptRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
}

Import-Module "$PSScriptRoot\utils.psm1" -Force

# Load buckets and packages from YAML config 
$configPath = Join-Path $ScriptRoot 'scoop_config.yaml'

if (!(Test-Path $configPath)) {
    Write-Host "`e[31m❌ scoop_config.yaml not found!`e[0m"
    exit 1
}

# Ensure powershell-yaml module is available
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    try {
        Install-Module powershell-yaml -Scope CurrentUser -Force -ErrorAction Stop
    } catch {
        Write-Host "`e[31m❌ Failed to install powershell-yaml module!`e[0m"
        exit 1
    }
}
Import-Module powershell-yaml

$config = ConvertFrom-Yaml (Get-Content $configPath -Raw)
$buckets = $config.buckets
$packages = $config.packages

# Define commit cache files
$last_commit_file = "$HOME\.dotfiles\.last_scoop_commit"
$last_scoop_config_mtime_file = "$HOME\.dotfiles\.last_scoop_config_mtime"

# Check if scoop_config.yaml was modified since last run
$scoop_config_mtime = (Get-Item $configPath).LastWriteTimeUtc
$scoop_config_timestamp = [int64]$scoop_config_mtime.ToFileTimeUtc()
$scoop_config_updated = $true
$last_run_timestamp = $null
if (Test-Path $last_scoop_config_mtime_file) {
    $last_run_timestamp_str = Get-Content $last_scoop_config_mtime_file | Select-Object -First 1
    if ([int64]::TryParse($last_run_timestamp_str, [ref]$last_run_timestamp)) {
        $scoop_config_updated = $scoop_config_timestamp -ne $last_run_timestamp
    } else {
        $scoop_config_updated = $true
    }
}

$dotfiles_updated = Test-DotfilesUpdate -CommitFile $last_commit_file

if ($Debug) {
    Write-Host "`e[36m[DEBUG] Last scoop commit file: $last_commit_file`e[0m"
    if (Test-Path $last_commit_file) {
        Write-Host "`e[36m[DEBUG] Last scoop commit:`e[0m $(Get-Content $last_commit_file | Select-Object -First 1)"
    } else {
        Write-Host "`e[36m[DEBUG] Last scoop commit: (none)`e[0m"
    }
    Write-Host "`e[36m[DEBUG] scoop_config.yaml timestamp: $scoop_config_timestamp`e[0m"
    if ($last_run_timestamp) {
        Write-Host "`e[36m[DEBUG] Last processed scoop_config.yaml timestamp: $last_run_timestamp`e[0m"
    } else {
        Write-Host "`e[36m[DEBUG] Last processed scoop_config.yaml timestamp: (none)`e[0m"
    }
}

if (-not ($dotfiles_updated -or $scoop_config_updated) -and -not $Force) {
    if (-not $Quiet) {
        Write-Host "`e[34m🔄 No changes in .dotfiles or scoop_config.yaml, skipping scoop package installation.`e[0m"
        Write-Host "Use -Force to force scoop package installation."
    }
    exit 0
}

# Add buckets
foreach ($bucket in $buckets) {
    scoop bucket add $bucket
}

# Install all packages in one go
scoop install @packages

# Update last run time for scoop_config.yaml
$scoop_config_timestamp | Set-Content $last_scoop_config_mtime_file
