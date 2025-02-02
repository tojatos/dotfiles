# Ensure the script stops on errors
$ErrorActionPreference = "Stop"

# Check if diff-so-fancy is already installed
if (Get-Command diff-so-fancy -ErrorAction SilentlyContinue) {
    Write-Host "diff-so-fancy is already installed, skipping"
    exit 0
}

# Ensure Scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop is not installed. Please install Scoop first."
    exit 1
}

# Install diff-so-fancy with Scoop
scoop install diff-so-fancy
if (-not (Get-Command diff-so-fancy -ErrorAction SilentlyContinue)) {
    Write-Host "Failed to install diff-so-fancy"
    exit 2
}

# Configure Git to use diff-so-fancy
& git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
& git config --bool --global diff-so-fancy.stripLeadingSymbols false

Write-Host "diff-so-fancy installed successfully"
