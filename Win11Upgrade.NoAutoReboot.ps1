# Configuration
$isoPath = "C:\Temp\Win11_24H2_English_x64.iso"
$logFile = "C:\Temp\Win11UpgradeLog.txt"
$transcriptFile = "C:\Temp\Win11UpgradeTranscript.txt"

# Start transcript to capture all output
Start-Transcript -Path $transcriptFile -Force

$timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFile -Value "`n[$timeStamp] Starting Windows 11 upgrade script..."

try {
    # Mount ISO
    Add-Content -Path $logFile -Value "Mounting ISO..."
    $mountResult = Mount-DiskImage -ImagePath $isoPath -PassThru -ErrorAction Stop
    $driveLetter = ($mountResult | Get-Volume).DriveLetter

    if (-not $driveLetter) {
        throw "Failed to get drive letter of mounted ISO."
    }

    $setupPath = "${driveLetter}:\setup.exe"
    Add-Content -Path $logFile -Value "ISO mounted as ${driveLetter}:"

    # Check if setup.exe exists
    if (-not (Test-Path $setupPath)) {
        throw "setup.exe not found at $setupPath"
    }
    Add-Content -Path $logFile -Value "setup.exe found at $setupPath"

    # Start Windows Setup silently, no auto reboot
    Add-Content -Path $logFile -Value "Starting silent upgrade with NO auto reboot..."
    $startTime = Get-Date
    $process = Start-Process -FilePath $setupPath `
        -ArgumentList "/auto upgrade /quiet /noreboot /dynamicupdate disable /eula accept" `
        -Wait -PassThru
    $endTime = Get-Date

    # Log exit code
    Add-Content -Path $logFile -Value "Upgrade process exited with code: $($process.ExitCode)"
    Add-Content -Path $logFile -Value "Upgrade duration: $([math]::Round(($endTime - $startTime).TotalMinutes, 2)) minutes"

    # Check if setup is still running (rare for /noreboot)
    Start-Sleep -Seconds 5
    $setupRunning = Get-Process -Name "setup" -ErrorAction SilentlyContinue
    if ($setupRunning) {
        Add-Content -Path $logFile -Value "setup.exe is still running with PID: $($setupRunning.Id)"
    } else {
        Add-Content -Path $logFile -Value "setup.exe not running post-launch. It may have completed or exited early."
    }

} catch {
    $errorMessage = "ERROR: $_"
    Add-Content -Path $logFile -Value $errorMessage
    exit 1
}
finally {
    # Always dismount the ISO
    Add-Content -Path $logFile -Value "Dismounting ISO..."
    Dismount-DiskImage -ImagePath $isoPath -ErrorAction SilentlyContinue
    Add-Content -Path $logFile -Value "Upgrade script completed. Awaiting user reboot."
    Stop-Transcript
}
