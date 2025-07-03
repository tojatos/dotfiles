Import-Module $PSScriptRoot\utils.psm1 -Force
$startup_dir = realpath "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$powershell_dir = realpath $(Split-Path -parent $profile)
$wt_settings_dir = realpath "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$config_dir = realpath "$HOME\.config"
# Define the dotfiles repo path and fingerprint directory
$fingerprint_dir = "$HOME\.dotfiles\.fingerprints"

# Define files for linking
$files = @{
    "profile.ps1"                = "$powershell_dir";
    "reposync.ps1"               = "$powershell_dir";
    "utils.psm1"                 = "$powershell_dir";
    "install_scoop_packages.ps1" = "$powershell_dir";
    "main.ahk"                   = "$startup_dir";
    "settings.json"              = "$wt_settings_dir";
    "..\shared\starship.toml"    = "$config_dir";
}

# Check which files need updating based on fingerprints
$files_to_update = Get-FilesNeedingUpdate -Files $files -FingerprintDir $fingerprint_dir

if ($files_to_update.Count -eq 0) {
    Write-Host "`e[90mLinking skipped - no file changes detected. To force run:`e[0m"
    Write-Host "`e[36mrm -r $fingerprint_dir`e[0m"
    exit 0
}

Write-Host "`e[90mStarting dotfiles linking process...`e[0m"
Write-Host "`e[90mFiles to update: $($files_to_update.Count) of $($files.Count)`e[0m"

# Function to check if two paths are on the same drive
function Is-SameDrive($path1, $path2) {
    return ($path1.Substring(0, 2) -eq $path2.Substring(0, 2))
}

# Process files that need updating
$successfully_linked = @()
$current_file = 0
$total_files = $files.Count

foreach ($file in $files.Keys) {
    $current_file++
    $source = "$HOME\.dotfiles\windows\$file"
    $filename = Split-Path -Leaf $file
    $target = "$($files[$file])\$filename"

    # Show progress
    $progress = "[$current_file/$total_files]"
    
    # Only process files that need updating
    if ($files_to_update -notcontains $file) {
        Write-Host "`e[90m$progress`e[0m `e[34m🔄`e[0m $filename `e[90m(unchanged)`e[0m"
        continue
    }

    if (!(Test-Path $source)) {
        Write-Host "`e[90m$progress`e[0m `e[33m⚠️`e[0m $filename `e[90m(source not found)`e[0m"
        continue
    }

    Write-Host "`e[90m$progress`e[0m `e[36m🔗`e[0m $filename `e[90m(linking...)`e[0m" -NoNewline

    # Remove conflicting file/link
    if (Test-Path $target) {
        Remove-Item -Force $target -ErrorAction SilentlyContinue
    }

    # Create the appropriate link
    if (Is-SameDrive $source $target) {
        $success = fsutil hardlink create $target $source 2>&1
    }
    else {
        $success = New-Item -ItemType SymbolicLink -Path $target -Target $source -ErrorAction SilentlyContinue 2>&1
    }

    if ($?) {
        Write-Host "`r`e[90m$progress`e[0m `e[32m✅`e[0m $filename `e[90m(linked)`e[0m"
        $successfully_linked += $file
    }
    else {
        Write-Host "`r`e[90m$progress`e[0m `e[31m❌`e[0m $filename `e[90m(failed)`e[0m"
        Write-Host "   `e[31mError: $success`e[0m"
    }
}

# Print summary
Write-Host "`e[90m`nLinking complete. Updated $($successfully_linked.Count) of $($files_to_update.Count) files.`e[0m"

# Update fingerprint cache for successfully linked files
if ($successfully_linked.Count -gt 0) {
    Update-FingerprintCache -Files $files -FingerprintDir $fingerprint_dir -ProcessedFiles $successfully_linked
}

