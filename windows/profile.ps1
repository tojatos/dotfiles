function Get-EnvVariable {
    param (
        [string]$key,
        [string]$default,
        [string]$envPath = "$PSScriptRoot\.env"
    )

    # Ensure the .env file exists
    if (-not (Test-Path $envPath)) {
        New-Item -Path $envPath -ItemType File -Force | Out-Null
    }

    # Read the file and check for the key
    $content = Get-Content $envPath -Raw
    if ($content -match "$key\s*=\s*(.+)") {
        return $matches[1].Trim()
    }

    # If not found, add the key with the default value
    Add-Content -Path $envPath -Value "`n$key=$default"
    return $default
}

$documents_path = [Environment]::GetFolderPath("MyDocuments")

$link_script = "$HOME\.dotfiles\windows\link.ps1"

if (Test-Path $link_script) {
    & $link_script
} else {
    Write-Warning "link.ps1 not found at $link_script"
}

Import-Module $PSScriptRoot\utils.psm1 -Force
# Add reposync command
$reposync_path = "$PSScriptRoot\reposync.ps1"
if (Test-Path $reposync_path) {
    . $reposync_path
} else {
    Write-Warning "reposync.ps1 not found"
}

# Install scoop packages if needed
$scoop_install_script = "$PSScriptRoot\install_scoop_packages.ps1"
if (Test-Path $scoop_install_script) {
    & $scoop_install_script -DotfilesWindowsRoot $HOME\.dotfiles\windows
} else {
    Write-Warning "install_scoop_packages.ps1 not found at $scoop_install_script"
}

# https://github.com/Schniz/fnm?tab=readme-ov-file#powershell
fnm env --use-on-cd | Out-String | Invoke-Expression

function New-And-Enter-Directory([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null; Set-Location $path}
Set-Alias take New-And-Enter-Directory

# utf-8 characters in git
$env:LC_ALL = "C.UTF-8"


${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# remove conflicting aliases for functions and conflicts with coreutils (scoop install coreutils)
$aliases_to_remove = @('gcm', 'gp', 'gl', 'rm', 'ls', 'mv', 'cp', 'cat', 'echo', 'clear')

foreach ($a in $aliases_to_remove) {
	Remove-Alias $a
}

function glsi { git ls-files -i -c --exclude-from=.gitignore }
function g { git status -s }
function ga { git add $args }
function gs { git show $args }
function gd { git diff $args }
function gdc { git diff --cached $args }
function gss { git status }
function gaa { git add -A }
function gcm { git commit -m $args }
function gp { git log --pretty --oneline --all --graph }
function gl { git log --graph --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) %C(cyan)<%an>%Creset' --abbrev-commit }
function amen { git commit --amen }
function ameno { git commit --amen --no-edit }
function ssync {
  git submodule sync --recursive
  git submodule update --init --recursive
}
function dsync { git submodule deinit --all -f }
function dtags { git log --tags --simplify-by-decoration --pretty="format:%ai %d" }
function gdm { git diff "master@{1}" master }
function gdiff { git diff --no-index $args }
function a { .venv/Scripts/activate }

function d { Set-Location "$documents_path/dokumenty" }
function dotfiles { cd $HOME\.dotfiles }
function ls {
    eza --icons --group-directories-first --color=always $args
}
function ll { ls -al $args }
function work {
    $workdir_path = Get-EnvVariable -key "WORKDIR_PATH" -default "C:\Scripts"
    if (-not (Test-Path $workdir_path)) {
        Write-Host "`n❌ ERROR: Directory '$workdir_path' not found!" -ForegroundColor Red
        Write-Host "➡️  To edit the .env file, run:" -ForegroundColor Yellow
        Write-Host "`n    vim `"$PSScriptRoot\.env`"`n" -ForegroundColor Cyan
    } else {
        Set-Location "$workdir_path"
    }
}
function ipa { Get-NetIPAddress | where AddressFamily -eq IPv4 | select InterfaceAlias,IPAddress | Format-Table }
function ssh-copy-id { cat ~/.ssh/id_rsa.pub | ssh $args "cat >> ~/.ssh/authorized_keys" }
function to_mp4 { ffmpeg -i $args "$([io.path]::GetFileNameWithoutExtension($args)).mp4" }
function refresh_path { $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") }
function edit_profile { vim ~/.dotfiles/windows/profile.ps1 }

function tif_to_pdf {
    param (
        [string[]]$inputPaths
    )

    # Expand wildcards but only for .tif files
    $expandedPaths = @()
    foreach ($path in $inputPaths) {
        if ($path -like "*`**") {
            $expandedPaths += Get-ChildItem -Path $path -Filter "*.tif" | Select-Object -ExpandProperty FullName
        } elseif ($path -match "\.tif$") {
            $expandedPaths += $path
        }
    }

    if ($expandedPaths.Count -eq 0) {
        Write-Host "No .tif files found." -ForegroundColor Red
        return
    }

    Write-Host "Found $($expandedPaths.Count) .tif files to convert:" -ForegroundColor Cyan
    foreach ($file in $expandedPaths) {
        Write-Host " - $file" -ForegroundColor Yellow
    }

    # Process each file
    foreach ($inputPath in $expandedPaths) {
        if (Test-Path $inputPath) {
            $outputPath = $inputPath -replace '\.tif$', '.pdf'

            Write-Host "`nConverting: $inputPath -> $outputPath" -ForegroundColor White
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

            try {
                magick "$inputPath" -quality 50 -compress jpeg -page A4 "$outputPath"
                $stopwatch.Stop()
                Write-Host "✅ Success:" -ForegroundColor Green -NoNewline
                Write-Host " $outputPath " -NoNewline
                Write-Host "(Time: $($stopwatch.ElapsedMilliseconds) ms)" -ForegroundColor Cyan
            } catch {
                Write-Host "❌ Error converting: $inputPath" -ForegroundColor Red
            }
        } else {
            Write-Host "⚠️ File not found: $inputPath" -ForegroundColor Magenta
        }
    }
}

function wifip {
  $profiles=(netsh wlan show profiles | Select-String "All User Profile\s+:\s+(.*)").Matches.Groups | Where-Object {$_.Value -notmatch "All User Profile*"} | Foreach {
    $wlan=netsh wlan show profiles name=$_ key=clear
      [pscustomobject][ordered]@{
        'SSID' = ($wlan | Select-String "SSID Name\s+:\s+(.*)").Matches.Groups[1].Value
          'Radio Type' = ($wlan | Select-String "Radio Type\s+:\s+(.*)").Matches.Groups[1].Value
          'Authentication' = ($wlan | Select-String "Authentication\s+:\s+(.*)").Matches.Groups[1].Value
          'Password' = ($wlan | Select-String "Key Content\s+:\s+(.*)").Matches.Groups[1].Value
      }
  } | Out-GridView -Title "Saved Wi-Fi passwords"
}

# https://stackoverflow.com/a/5501909/7136056
function Reload-Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }
}

refresh_path # in case anything got installed
Invoke-Expression (&starship init powershell)

Set-PSReadLineOption -EditMode Emacs # emacs bindings, invoke first
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete # better tab completion, needs to be invoked after emacs bindings
Set-PSReadlineOption -BellStyle None # disable annoying beeps

# FZF bindings
if (Get-Command "fzf" -ErrorAction SilentlyContinue)
{
	Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}
