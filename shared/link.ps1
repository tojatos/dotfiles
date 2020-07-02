Import-Module $PSScriptRoot\utils.psm1 -Force

$links = @{
    ".vimrc"="$HOME";
    ".vim"="$HOME";
    ".ideavimrc"="$HOME";
    ".ssh\config"="$HOME\.ssh";
}

foreach ($l in $links.GetEnumerator()) {
    $file_name = $($l.Name).split('\') | Select-Object -Last 1
    Write-Info "Linking $file_name to $($l.Value)"
    $file_path = realpath ([IO.Path]::Combine($l.Value, $file_name))
    $linked_path = realpath $file_name
    if ([IO.File]::Exists($file_path)) {
        Write-Error "File already exists."
    } else {
        New-Link $file_path $linked_path | Out-Null
        Write-Success "Link created"
    }
}
