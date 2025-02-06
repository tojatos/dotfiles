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
        # Run git pull on all repositories asynchronously when no arguments are provided
        $paths = Get-Content -Path $listFile
        if ($paths.Count -eq 0) {
            Write-Host "Warning: No paths in the list." -ForegroundColor Yellow
            return
        }

        $jobs = @()
        foreach ($repoPath in $paths) {
            if (-not (Test-Path $repoPath)) {
                Write-Host "Error: Path does not exist - $repoPath" -ForegroundColor Red
                continue
            }

            # Start a background job for each repository.
            $job = Start-Job -ScriptBlock {
                param($repoPath)
                $output = @()
                Set-Location -Path $repoPath

                try {
                    $status = git status --porcelain
                    if ($status) {
                        $output += [PSCustomObject]@{ Message = "Warning: Local changes detected in $repoPath"; Color = "Yellow" }
                        foreach ($line in $status) {
                            $changeType = $line.Substring(0, 2).Trim()
                            $filePath = $line.Substring(3).Trim()
                            switch ($changeType) {
                                'M' { $output += [PSCustomObject]@{ Message = "M  $filePath"; Color = "Cyan" } }
                                'A' { $output += [PSCustomObject]@{ Message = "A  $filePath"; Color = "Green" } }
                                'D' { $output += [PSCustomObject]@{ Message = "D  $filePath"; Color = "Red" } }
                                'R' { $output += [PSCustomObject]@{ Message = "R  $filePath"; Color = "Magenta" } }
                                default { $output += [PSCustomObject]@{ Message = "$changeType  $filePath"; Color = "Yellow" } }
                            }
                        }
                        # If there are local changes, skip pulling.
                        return $output
                    }

                    $oldCommit = git rev-parse HEAD
                    $pullResult = git pull 2>&1

                    if ($pullResult -match 'Already up to date.') {
                        $output += [PSCustomObject]@{ Message = "$repoPath is up to date."; Color = "Green" }
                    }
                    elseif ($pullResult -match 'Updating') {
                        $newCommit = git rev-parse HEAD
                        $commitLogs = git log "$oldCommit..$newCommit" --pretty=format:"%h %s" -n 3
                        $commitCount = (git rev-list "$oldCommit..$newCommit" --count) - 3

                        $output += [PSCustomObject]@{ Message = "Successfully pulled changes in ${repoPath}:"; Color = "Green" }
                        $output += [PSCustomObject]@{ Message = "Old Commit: $oldCommit"; Color = "White" }
                        $output += [PSCustomObject]@{ Message = "New Commit: $newCommit"; Color = "White" }
                        foreach ($log in $commitLogs) {
                            $output += [PSCustomObject]@{ Message = " - $log"; Color = "White" }
                        }
                        if ($commitCount -gt 0) {
                            $output += [PSCustomObject]@{ Message = "... and $commitCount more commits."; Color = "White" }
                        }
                    }
                    else {
                        $output += [PSCustomObject]@{ Message = "Error: Issue while pulling $repoPath"; Color = "Red" }
                    }
                }
                catch {
                    $output += [PSCustomObject]@{ Message = "Error: Exception while processing $repoPath"; Color = "Red" }
                    $output += [PSCustomObject]@{ Message = $_.Exception.Message; Color = "Red" }
                }
                return $output
            } -ArgumentList $repoPath

            # Tag the job with its repo path so we know where the output is from.
            $job | Add-Member -MemberType NoteProperty -Name RepoPath -Value $repoPath
            $jobs += $job
        }

        $totalJobs = $jobs.Count

        # Poll for finished jobs and print their outputs immediately.
        while ($jobs.Count -gt 0) {
            foreach ($job in @($jobs)) {
                if ($job.State -eq 'Completed') {
                    $results = Receive-Job -Job $job
                    # Print a header to separate outputs.
                    Write-Host "========== Repo: $($job.RepoPath) ==========" -ForegroundColor Cyan
                    foreach ($item in $results) {
                        Write-Host $item.Message -ForegroundColor $item.Color
                    }
                    Write-Host ""
                    # Remove the finished job from the list.
                    $jobs = $jobs | Where-Object { $_.Id -ne $job.Id }
                }
            }
            $completedJobs = $totalJobs - $jobs.Count
            $percent = [math]::Round(($completedJobs / $totalJobs) * 100, 0)
            Write-Progress -Activity "Syncing Repositories" -Status "Completed $completedJobs of $totalJobs" -PercentComplete $percent
            Start-Sleep -Seconds 0.5
        }
        Write-Progress -Activity "Syncing Repositories" -Completed
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
            }
            else {
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
            }
            else {
                Write-Host "Please provide a path to delete." -ForegroundColor Yellow
            }
        }
        'list' {
            $paths = Get-Content -Path $listFile
            if ($paths.Count -eq 0) {
                Write-Host "No paths in the list." -ForegroundColor Yellow
            }
            else {
                Write-Host "Tracked paths:" -ForegroundColor Cyan
                $paths | ForEach-Object { Write-Host $_ -ForegroundColor White }
            }
        }
        'edit' {
            if (Test-Path $listFile) {
                vim $listFile
            }
            else {
                Write-Host "Error: List file does not exist." -ForegroundColor Red
            }
        }
        '--help' {
            Write-Host "Usage: reposync <action> [path]" -ForegroundColor Cyan
            Write-Host "Actions:" -ForegroundColor Cyan
            Write-Host "  <no action>    - Runs 'git pull' on all repositories in the list asynchronously with a progress bar." -ForegroundColor Cyan
            Write-Host "                   Each repo's logs are printed immediately when it is synced." -ForegroundColor Cyan
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
