Import-Module $PSScriptRoot\utils.psm1 -Force
$startup_dir = realpath "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$powershell_dir = realpath $(Split-Path -parent $profile)
$wt_settings_dir = realpath "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# Define files for linking
$files = @{
    "profile.ps1" = "$powershell_dir";
    "reposync.ps1" = "$powershell_dir";
    "utils.psm1" = "$powershell_dir";
    "main.ahk" = "$startup_dir";
    "settings.json" = "$wt_settings_dir";
}

# Function to check if two paths are on the same drive
function Is-SameDrive($path1, $path2) {
    return ($path1.Substring(0,2) -eq $path2.Substring(0,2))
}

# Define animation frames
$frames = @("-", "\", "|", "/")
$frameIndex = 0
$statusIcons = @()
$errors = @()

# Show animation while linking
for ($i = 0; $i -lt 10; $i++) {
    $frame = $frames[$frameIndex]
    $frameIndex = ($frameIndex + 1) % $frames.Length
    Write-Host "`r$frame Linking files... " -NoNewline
    Start-Sleep -Milliseconds 100
}

# Process files
foreach ($file in $files.Keys) {
    $source = "$HOME\.dotfiles\windows\$file"
    $target = "$($files[$file])\$file"

    if (!(Test-Path $source)) {
        $statusIcons += "`e[33m⚠️`e[0m"  # Yellow warning (skipped)
        continue
    }

    # Skip if valid link already exists
    if (Test-Path $target) {
        $existing_item = Get-Item $target -ErrorAction SilentlyContinue
        if ($existing_item -and $existing_item.LinkType -eq "SymbolicLink") {
            $statusIcons += "`e[34m🔄`e[0m"  # Blue (already linked)
            continue
        }
    }

    # Remove conflicting file
    if (Test-Path $target) {
        Remove-Item -Force $target -ErrorAction SilentlyContinue
    }

    # Create the appropriate link
    if (Is-SameDrive $source $target) {
        $success = fsutil hardlink create $target $source 2>&1
    } else {
        $success = New-Item -ItemType SymbolicLink -Path $target -Target $source -ErrorAction SilentlyContinue 2>&1
    }

    if ($?) {
        $statusIcons += "`e[32m✅`e[0m"  # Green (successfully linked)
    } else {
        $statusIcons += "`e[31m❌`e[0m"  # Red (failed)
        $errors += "❌ Error linking $file → $target : $success"
    }

    # Show animation while processing
    $frame = $frames[$frameIndex]
    $frameIndex = ($frameIndex + 1) % $frames.Length
    Write-Host "`r$frame Linking files... " -NoNewline
}

# Clear animation and print final result in one line
Write-Host "`r`e[KLinking result: $($statusIcons -join ' ')"

# Print errors separately
if ($errors.Count -gt 0) {
    $errors -join "`n" | Write-Host
}
