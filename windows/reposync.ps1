function reposync {
    param (
        [string]$action,
        [string]$path
    )

    $listFile = "$PSScriptRoot\reposync_paths.txt"

    # Initialize the file if it doesn't exist
    if (-not (Test-Path $listFile)) {
        New-Item -Path $listFile -ItemType File -Force | Out-Null
    }

    if (-not $action) {
        # Run git pull on all repos when no arguments are provided
        $paths = Get-Content -Path $listFile
        if ($paths.Count -eq 0) {
            Write-Host "Warning: No paths in the list." -ForegroundColor Yellow
            return
        }
        foreach ($repoPath in $paths) {
            if (-not (Test-Path $repoPath)) {
                Write-Host "Error: Path does not exist - $repoPath" -ForegroundColor Red
                continue
            }

            Set-Location -Path $repoPath

            try {
                $status = git status --porcelain
                if ($status) {
                    Write-Host "Warning: Local changes detected in $repoPath" -ForegroundColor Yellow
                    $status | ForEach-Object {
                        $changeType = $_.Substring(0, 2).Trim()
                        $filePath = $_.Substring(3).Trim()
                        switch ($changeType) {
                            'M' { Write-Host "M" -ForegroundColor Cyan -NoNewline; Write-Host " $filePath" }
                            'A' { Write-Host "A" -ForegroundColor Green -NoNewline; Write-Host " $filePath" }
                            'D' { Write-Host "D" -ForegroundColor Red -NoNewline; Write-Host " $filePath" }
                            'R' { Write-Host "R" -ForegroundColor Magenta -NoNewline; Write-Host " $filePath" }
                            default { Write-Host "$changeType" -ForegroundColor Yellow -NoNewline; Write-Host " $filePath" }
                        }
                    }
                    continue
                }

                $oldCommit = git rev-parse HEAD
                $pullResult = git pull 2>&1

                if ($pullResult -match 'Already up to date.') {
                    Write-Host "$repoPath is up to date." -ForegroundColor Green
                } elseif ($pullResult -match 'Updating') {
                    $newCommit = git rev-parse HEAD
                    $commitLogs = git log $oldCommit..$newCommit --pretty=format:"%h %s" -n 3
                    $commitCount = (git rev-list $oldCommit..$newCommit --count) - 3

                    Write-Host "Successfully pulled changes in ${repoPath}:" -ForegroundColor Green
                    Write-Host "Old Commit: $oldCommit"
                    Write-Host "New Commit: $newCommit"
                    $commitLogs | ForEach-Object { Write-Host " - $_" }
                    if ($commitCount -gt 0) {
                        Write-Host "... and $commitCount more commits."
                    }
                } else {
                    Write-Host "Error: Issue while pulling $repoPath" -ForegroundColor Red
                }
            } catch {
                Write-Host "Error: Exception while processing $repoPath" -ForegroundColor Red
                Write-Host $_.Exception.Message
            }
        }
        # Return to the original location
        Set-Location -Path (Get-Location -PSProvider FileSystem).Path
        return
    }

    switch ($action) {
        'add' {
            if ($path) {
                $resolvedPath = Resolve-Path -Path $path
                $existingPaths = Get-Content -Path $listFile
                if ($existingPaths -contains $resolvedPath) {
                    Write-Host "Error: Path already exists in the list." -ForegroundColor Red
                    return
                }
                Add-Content -Path $listFile -Value $resolvedPath
                Write-Host "Added path: $resolvedPath" -ForegroundColor Green
            } else {
                Write-Host "Please provide a path to add." -ForegroundColor Yellow
            }
        }
        'delete' {
            if ($path) {
                $resolvedPath = Resolve-Path -Path $path
                $paths = Get-Content -Path $listFile
                $updatedPaths = $paths | Where-Object { $_.Trim() -ne $resolvedPath.ToString().Trim() }
                $updatedPaths | Set-Content -Path $listFile
                Write-Host "Deleted path: $resolvedPath" -ForegroundColor Green
            } else {
                Write-Host "Please provide a path to delete." -ForegroundColor Yellow
            }
        }
        'list' {
            $paths = Get-Content -Path $listFile
            if ($paths.Count -eq 0) {
                Write-Host "No paths in the list." -ForegroundColor Yellow
            } else {
                Write-Host "Tracked paths:" -ForegroundColor Cyan
                $paths | ForEach-Object { Write-Host $_ }
            }
        }
        'edit' {
            if (Test-Path $listFile) {
                vim $listFile
            } else {
                Write-Host "Error: List file does not exist." -ForegroundColor Red
            }
        }
        '--help' {
            Write-Host "Usage: reposync <action> [path]" -ForegroundColor Cyan
            Write-Host "Actions:" -ForegroundColor Cyan
            Write-Host "  <no action>    - Runs 'git pull' on all repositories in the list." -ForegroundColor Cyan
            Write-Host "  add <path>     - Adds a path to the list." -ForegroundColor Cyan
            Write-Host "  delete <path>  - Deletes a path from the list." -ForegroundColor Cyan
            Write-Host "  list           - Lists all tracked paths." -ForegroundColor Cyan
            Write-Host "  edit           - Opens the list file in vim." -ForegroundColor Cyan
        }
        default {
            Write-Host "Error: Invalid action '$action'. Use '--help' for usage information." -ForegroundColor Red
        }
    }
}
