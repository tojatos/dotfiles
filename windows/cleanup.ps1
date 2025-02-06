# Kernel memory crash dump files
Remove-Item -Path "C:\Windows\LiveKernelReports\*.dmp" -Force

### General cleanup
# Set what to cleanup with:
# cleanmgr /sageset:1

# Run Disk Cleanup silently
Start-Process cleanmgr -ArgumentList "/sagerun:1" -NoNewWindow -Wait

# Windows Update Cleanup
Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase

# Remove temp files
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Update Cache
Stop-Service wuauserv -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv

# Empty Recycle Bin
Clear-RecycleBin -Force -Confirm:$false

# Shrink docker WSL
./shrink_docker_wsl.ps1

Write-Host "Cleanup completed successfully!" -ForegroundColor Green
