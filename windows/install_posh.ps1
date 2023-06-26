$packageInstalled = winget list --id JanDeDobbeleer.OhMyPosh
if (!$packageInstalled) {
  winget install JanDeDobbeleer.OhMyPosh -s winget
}
