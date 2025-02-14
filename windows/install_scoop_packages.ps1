Import-Module $PSScriptRoot\utils.psm1 -Force

# Define commit cache file
$last_commit_file = "$HOME\.dotfiles\.last_scoop_commit"

# Check if dotfiles have been updated
if (-not (Test-DotfilesUpdate -CommitFile $last_commit_file)) {
    # Write-Host "`e[34m🔄 No changes in .dotfiles, skipping scoop package installation.`e[0m"
    exit 0
}

# Required buckets
$buckets = @(
    "extras",
    "nerd-fonts"
)

# List of scoop packages to install
$packages = @(
    "clink",
    "clink-flex-prompt",
    "clink-completions",
    "FiraCode-NF",
    "eza",
    # "signal",
    "coreutils"
)

# Animation frames for installation progress
$frames = @("-", "\", "|", "/")
$frameIndex = 0
$statusIcons = @()
$errors = @()

# Show animation while installing
for ($i = 0; $i -lt 10; $i++) {
    $frame = $frames[$frameIndex]
    $frameIndex = ($frameIndex + 1) % $frames.Length
    Write-Host "`r$frame Setting up scoop... " -NoNewline
    Start-Sleep -Milliseconds 100
}

# Add buckets first
foreach ($bucket in $buckets) {
    # Check if bucket is already added
    $installed = scoop bucket list | Where-Object { $_.Name -eq $bucket }
    
    if ($installed) {
        $statusIcons += "`e[34m🔄`e[0m"  # Blue (already installed)
        continue
    }

    # Try to add the bucket
    $result = scoop bucket add $bucket 2>&1
    if ($?) {
        $statusIcons += "`e[32m✅`e[0m"  # Green (successfully added)
    } else {
        $statusIcons += "`e[31m❌`e[0m"  # Red (failed)
        $errors += "❌ Error adding bucket $bucket : $result"
    }

    # Show animation while processing
    $frame = $frames[$frameIndex]
    $frameIndex = ($frameIndex + 1) % $frames.Length
    Write-Host "`r$frame Adding buckets... " -NoNewline
}

# Check and install packages
foreach ($package in $packages) {
    # Check if package is already installed
    $installed = $null
    $installed = scoop list $package *>&1
    if ($installed -match $package) {
        $statusIcons += "`e[34m🔄`e[0m"  # Blue (already installed)
        continue
    }

    # Try to install the package
    $result = scoop install $package 2>&1
    if ($?) {
        $statusIcons += "`e[32m✅`e[0m"  # Green (successfully installed)
    } else {
        $statusIcons += "`e[31m❌`e[0m"  # Red (failed)
        $errors += "❌ Error installing $package : $result"
    }

    # Show animation while processing
    $frame = $frames[$frameIndex]
    $frameIndex = ($frameIndex + 1) % $frames.Length
    Write-Host "`r$frame Installing packages... " -NoNewline
}

# Clear animation and print final result in one line
Write-Host "`r`e[KInstallation result: $($statusIcons -join ' ')"

# Print errors separately
if ($errors.Count -gt 0) {
    $errors -join "`n" | Write-Host
    exit 1
}
