param(
    [switch]$Force
)

Import-Module $PSScriptRoot\utils.psm1 -Force

# Load buckets and packages from YAML config
$configPath = Join-Path $PSScriptRoot 'scoop_config.yaml'
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

# Define commit cache file
$last_commit_file = "$HOME\.dotfiles\.last_scoop_commit"

# Check if dotfiles have been updated
if (-not (Test-DotfilesUpdate -CommitFile $last_commit_file) -and -not $Force) {
    Write-Host "`e[34m🔄 No changes in .dotfiles, skipping scoop package installation.`e[0m"
    Write-Host "Use -Force to force scoop package installation."
    exit 0
}

# Add buckets
foreach ($bucket in $buckets) {
    scoop bucket add $bucket
}

# Install all packages in one go
scoop install @packages
