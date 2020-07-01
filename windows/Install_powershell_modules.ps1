$modules = @("posh-git"; "oh-my-posh"; "PSFzf")
foreach ($module in $modules) {
    Install-Module $module -Force
}
