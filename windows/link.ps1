Import-Module $PSScriptRoot\utils.psm1 -Force
$startup_dir = realpath "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$powershell_dir = realpath "E:\Documents\PowerShell"

$links = @{
    "profile.ps1"="$powershell_dir";
    "utils.psm1"="$powershell_dir";
    "main.ahk"="$startup_dir";
}

foreach ($l in $links.GetEnumerator()) {
    Write-Info "Linking $($l.Name) to $($l.Value)"
    $file_path = realpath ([IO.Path]::Combine($l.Value, $l.Name))
    $linked_path = realpath $l.Name
    if ([IO.File]::Exists($file_path)) {
        Write-Error "File already exists."
    } else {
        New-Link $file_path $linked_path | Out-Null
        Write-Success "Link created"
    }
}

