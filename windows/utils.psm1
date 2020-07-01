function Write-Info ($msg) {
    Write-Host $msg -ForegroundColor Yellow
}

function Write-Success ($msg) {
    Write-Host $msg -ForegroundColor Green
}

function Write-Error ($msg) {
    Write-Host $msg -ForegroundColor Red
}

function New-Link ($path, $value) {
    New-Item -Path $path -ItemType SymbolicLink -Value $value
}

# Resolve-Path that returns even if the file does not exists
function Resolve-PathForce ($path) {
   return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
}

function Remove-Alias ([string] $AliasName) {
	while (Test-Path Alias:$AliasName) {
		Remove-Item Alias:$AliasName -Force 2> $null
	}
}


Set-Alias realpath Resolve-PathForce
