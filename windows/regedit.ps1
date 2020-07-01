Set-Location regedit
$reg_files = Get-ChildItem
foreach ($r in $reg_files) {
    Invoke-Item $r
}