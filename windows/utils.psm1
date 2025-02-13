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

function Test-DotfilesUpdate {
    param (
        [string]$CommitFile
    )
    
    $dotfiles_repo = "$HOME\.dotfiles"
    
    # Get current commit hash
    $current_commit = (git -C $dotfiles_repo rev-parse HEAD 2>$null).Trim()
    
    # Read last recorded commit hash (trim newlines)
    if (Test-Path $CommitFile) {
        $last_commit = (Get-Content $CommitFile -Raw).Trim()
    } else {
        $last_commit = ""
    }
    
    # If the commit hasn't changed, return false
    if ($current_commit -eq $last_commit) {
        return $false
    }
    
    # Save the new commit hash without extra newlines
    Set-Content -Path $CommitFile -Value $current_commit.Trim()
    return $true
}

Set-Alias realpath Resolve-PathForce
