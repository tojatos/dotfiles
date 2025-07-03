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

function Get-FileFingerprint {
    param (
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        return $null
    }
    
    $hash = Get-FileHash -Path $FilePath -Algorithm SHA256
    return $hash.Hash
}

function Get-FingerprintFileName {
    param (
        [string]$File
    )
    
    # Handle relative paths by extracting just the filename
    $filename = Split-Path -Leaf $File
    return "$filename.fingerprint"
}

function Get-FilesNeedingUpdate {
    param (
        [hashtable]$Files,
        [string]$FingerprintDir
    )
    
    # Ensure fingerprint directory exists
    if (-not (Test-Path $FingerprintDir)) {
        New-Item -ItemType Directory -Path $FingerprintDir -Force | Out-Null
    }
    
    $filesToUpdate = @()
    
    foreach ($file in $Files.Keys) {
        $source = "$HOME\.dotfiles\windows\$file"
        $currentFingerprint = Get-FileFingerprint $source
        
        if ($currentFingerprint -eq $null) {
            continue  # Skip files that don't exist
        }
        
        # Get cached fingerprint from individual file
        $fingerprintFile = Join-Path $FingerprintDir (Get-FingerprintFileName $file)
        $cachedFingerprint = $null
        
        if (Test-Path $fingerprintFile) {
            $cachedFingerprint = (Get-Content $fingerprintFile -Raw).Trim()
        }
        
        if ($currentFingerprint -ne $cachedFingerprint) {
            $filesToUpdate += $file
        }
    }
    
    return $filesToUpdate
}

function Update-FingerprintCache {
    param (
        [hashtable]$Files,
        [string]$FingerprintDir,
        [array]$ProcessedFiles
    )
    
    # Ensure fingerprint directory exists
    if (-not (Test-Path $FingerprintDir)) {
        New-Item -ItemType Directory -Path $FingerprintDir -Force | Out-Null
    }
    
    # Update fingerprints for processed files
    foreach ($file in $ProcessedFiles) {
        $source = "$HOME\.dotfiles\windows\$file"
        $fingerprint = Get-FileFingerprint $source
        
        if ($fingerprint -ne $null) {
            $fingerprintFile = Join-Path $FingerprintDir (Get-FingerprintFileName $file)
            Set-Content -Path $fingerprintFile -Value $fingerprint
        }
    }
}

Set-Alias realpath Resolve-PathForce
