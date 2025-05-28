# Helper function to check if a cleanup task was run today and to update the timestamp
function Invoke-CleanupTask {
    param (
        [string]$TaskName,
        [scriptblock]$CleanupAction
    )

    $timestampDir = Join-Path -Path $PSScriptRoot -ChildPath "timestamps"
    if (-not (Test-Path $timestampDir)) {
        New-Item -ItemType Directory -Path $timestampDir -Force | Out-Null
    }

    $timestampFile = Join-Path -Path $timestampDir -ChildPath "$TaskName.txt"
    $today = (Get-Date).ToString("yyyy-MM-dd")
    $skipMessage = "Skipping '$TaskName' as it was already run today."

    if (Test-Path $timestampFile) {
        $lastRunDate = Get-Content $timestampFile
        if ($lastRunDate -eq $today) {
            Write-Host $skipMessage -ForegroundColor Cyan
            return
        }
    }

    Write-Host "Running cleanup task: '$TaskName'..." -ForegroundColor Yellow
    Invoke-Command -ScriptBlock $CleanupAction
    Set-Content -Path $timestampFile -Value $today -Force
    Write-Host "Finished cleanup task: '$TaskName'." -ForegroundColor Green
}

# Kernel memory crash dump files
Invoke-CleanupTask -TaskName "KernelMemoryDumpCleanup" -CleanupAction {
    Remove-Item -Path "C:\\Windows\\LiveKernelReports\\*.dmp" -Force -ErrorAction SilentlyContinue
}

### General cleanup
# Set what to cleanup with:
# cleanmgr /sageset:1

# Run Disk Cleanup silently
Invoke-CleanupTask -TaskName "DiskCleanup" -CleanupAction {
    Start-Process cleanmgr -ArgumentList "/sagerun:1" -NoNewWindow -Wait
}

# Windows Update Cleanup
Invoke-CleanupTask -TaskName "WindowsUpdateCleanup" -CleanupAction {
    Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
}

# Remove temp files
Invoke-CleanupTask -TaskName "TempFilesCleanup" -CleanupAction {
    Remove-Item -Path "C:\\Windows\\Temp\\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Clear Windows Update Cache
Invoke-CleanupTask -TaskName "WindowsUpdateCacheCleanup" -CleanupAction {
    Stop-Service wuauserv -Force
    Remove-Item -Path "C:\\Windows\\SoftwareDistribution" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service wuauserv
}

# Empty Recycle Bin
Invoke-CleanupTask -TaskName "EmptyRecycleBin" -CleanupAction {
    Clear-RecycleBin -Force -Confirm:$false
}

# Shrink docker WSL
Invoke-CleanupTask -TaskName "ShrinkDockerWSL" -CleanupAction {
    ./shrink_docker_wsl.ps1
}

# Remove Windows.old folder
Invoke-CleanupTask -TaskName "RemoveWindowsOld" -CleanupAction {
    if (Test-Path "C:\\Windows.old") {
        Remove-Item -Path "C:\\Windows.old\" -Recurse -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "Windows.old folder not found." -ForegroundColor Cyan
    }
}

# Disable Hibernation
# Invoke-CleanupTask -TaskName "DisableHibernation" -CleanupAction {
# powercfg /hibernate off
# }

# Clear DirectX Shader Cache
Invoke-CleanupTask -TaskName "ClearDirectXShaderCache" -CleanupAction {
    Remove-Item -Path "$env:LOCALAPPDATA\\NVIDIA\\DXCache\\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\\D3DSCache\\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\\AMD\\DxCache\\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Remove Delivery Optimization Files
Invoke-CleanupTask -TaskName "RemoveDeliveryOptimizationFiles" -CleanupAction {
    Remove-Item -Path "C:\\Windows\\SoftwareDistribution\\DeliveryOptimization\\*" -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "All cleanup tasks processed." -ForegroundColor Green
