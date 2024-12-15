param(
    [string]$UserProfilePath = "$env:USERPROFILE"
    )

# Function to log messages
function Log-Message {
  param(
      [string]$message
      )
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $message"
}

# Function to find the ext4.vhdx file for Docker WSL
function Find-VHDPath {
  param(
      [string]$basePath
      )

    $vhdPath = Get-ChildItem -Path "$basePath\AppData\Local\Docker\wsl\data" -Filter "*.vhdx" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

    if (-not $vhdPath) {
      Log-Message "No VHD file found in $basePath\AppData\Local\Docker\wsl\data"
        return $null
    }
    else {
      Log-Message "Found VHD file at: $vhdPath"
        return $vhdPath
    }
}

# Function to shutdown WSL
function Shutdown-WSL {
  Log-Message "Shutting down WSL..."
    wsl --shutdown
    if ($LASTEXITCODE -eq 0) {
      Log-Message "WSL shutdown successfully."
    }
    else {
      Log-Message "Error occurred while shutting down WSL."
    }
}

# Function to compact the VHD file using PowerShell Direct Compact (no Hyper-V required)
function Compact-VHDFile {
  param(
      [string]$vhdPath
      )

    if (-not (Test-Path -Path $vhdPath)) {
      Log-Message "The specified VHD file does not exist: $vhdPath"
        return
    }

  Log-Message "Starting to compact VHD file: $vhdPath"
    try {
# Use diskpart to compact VHD file as Hyper-V is not available
      $diskpartCommands = @(
          "select vdisk file='$vhdPath'",
          "compact vdisk"
          )

        $diskpartCommands | Out-File -FilePath "diskpart_script.txt" -Encoding utf8
        diskpart /s diskpart_script.txt

        Log-Message "VHD file compacted successfully."
        Remove-Item -Path "diskpart_script.txt" -Force
    }
  catch {
    Log-Message "Error occurred while compacting the VHD file: $_"
  }
}

# Main script execution
try {
  Log-Message "Starting VHD optimization script."

# Shutdown WSL to ensure no process is using the VHD file
    Shutdown-WSL

# Find the VHD path
    $vhdPath = Find-VHDPath -basePath $UserProfilePath

    if ($vhdPath) {
# Compact the VHD file
      Compact-VHDFile -vhdPath $vhdPath
    }
    else {
      Log-Message "No VHD file found to compact. Exiting script."
    }

}
catch {
  Log-Message "An unexpected error occurred: $_"
}
finally {
  Log-Message "Script execution completed."
}
