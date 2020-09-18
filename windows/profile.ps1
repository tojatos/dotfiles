Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

Import-Module $PSScriptRoot\utils.psm1 -Force

function New-And-Enter-Directory([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null; Set-Location $path}
Set-Alias take New-And-Enter-Directory

Set-PSReadlineKeyHandler -Key Tab -Function Complete # bash like tab completion
Set-PSReadlineOption -BellStyle None # disable annoying beeps
Set-PSReadLineOption -EditMode Emacs # emacs bindings

# utf-8 characters in git
$env:LC_ALL = "C.UTF-8"

# FZF bindings
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

$aliases_to_remove = @('gcm', 'gp', 'gl')

foreach ($a in $aliases_to_remove) {
	Remove-Alias $a
}

function glsi { git ls-files -i --exclude-from=.gitignore }
function g { git status }
function ga { git add $args }
function gs { git show $args }
function gd { git diff $args }
function gdc { git diff --cached $args }
function gss { git status -s }
function gaa { git add -A }
function gcm { git commit -m $args }
function gp { git log --pretty --oneline --all --graph }
function gl { git log --graph --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) %C(cyan)<%an>%Creset' --abbrev-commit }
function ameno { git commit --amen --no-edit }
function ssync {
  git submodule sync --recursive
  git submodule update --init --recursive
}
function dsync { git submodule deinit --all -f }
function dtags { git log --tags --simplify-by-decoration --pretty="format:%ai %d" }
function gdm { git diff master@{1} master }

function pwr { Set-Location D:\Documents\PWR4 }
function d { Set-Location D:\Documents }
function work { Set-Location D:\Scripts }
function ipa { Get-NetIPAddress | where AddressFamily -eq IPv4 | select InterfaceAlias,IPAddress | Format-Table }
function ssh-copy-id { cat ~/.ssh/id_rsa.pub | ssh $args "cat >> ~/.ssh/authorized_keys" }
function to_mp4 { ffmpeg -i $args "$([io.path]::GetFileNameWithoutExtension($args)).mp4" }
