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
    [string]$basePath,
    [string]$subDirName
  )

  $searchPaths = @()
  if ($subDirName -eq "Docker") {
    $searchPaths += Join-Path -Path $basePath -ChildPath "AppData\\Local\\Docker\\wsl\\data"
  }
  elseif ($subDirName -eq "rancher-desktop") {
    $searchPaths += Join-Path -Path $basePath -ChildPath "AppData\\Local\\rancher-desktop"
    # Also check common WSL data path for rancher-desktop, just in case
    $searchPaths += Join-Path -Path $basePath -ChildPath "AppData\\Local\\rancher-desktop\\wsl\\data"
  }
  else {
    # Default search patterns for other potential VHD locations
    $searchPaths += Join-Path -Path $basePath -ChildPath "AppData\\Local\\$subDirName\\wsl\\data"
    $searchPaths += Join-Path -Path $basePath -ChildPath "AppData\\Local\\$subDirName"
  }

  foreach ($searchPath in $searchPaths) {
    Log-Message "Searching for VHD in $searchPath"
    if (Test-Path $searchPath) {
      $vhdPath = Get-ChildItem -Path $searchPath -Filter "*.vhdx" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
      if ($vhdPath) {
        Log-Message "Found VHD file at: $vhdPath"
        return $vhdPath
      }
    }
    else {
      Log-Message "Search path does not exist: $searchPath"
    }
  }

  Log-Message "No VHD file found for $subDirName in the specified locations."
  return $null
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

  # Define the application names to search for
  $appNames = @("Docker", "rancher-desktop")

  foreach ($appName in $appNames) {
    Log-Message "Attempting to find and compact VHD for $appName"
    # Find the VHD path
    $vhdPath = Find-VHDPath -basePath $UserProfilePath -subDirName $appName

    if ($vhdPath) {
      # Compact the VHD file
      Compact-VHDFile -vhdPath $vhdPath
    }
    else {
      Log-Message "No VHD file found for $appName. Skipping."
    }
  }
}
catch {
  Log-Message "An unexpected error occurred: $_"
}
finally {
  Log-Message "Script execution completed."
}
