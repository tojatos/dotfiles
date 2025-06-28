#####
# remove old posh
# https://ohmyposh.dev/docs/migrating
Remove-Item $env:POSH_PATH -Force -Recurse
Uninstall-Module oh-my-posh -AllVersions
#####

winget install JanDeDobbeleer.OhMyPosh -s winget
