$CPU = Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty Name
$GPU = Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name
$RAM = [math]::round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$Disks = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, MediaType, @{Name="Size(GB)";Expression={"{0:N2}" -f ($_.Size/1GB)}}

Write-Output "CPU: $CPU"
Write-Output "GPU: $GPU"
Write-Output "RAM: $RAM GB"
Write-Output "Disks:"
$Disks | ForEach-Object {
    Write-Output "$($_.Model): $($_.'Size(GB)') GB"
}
