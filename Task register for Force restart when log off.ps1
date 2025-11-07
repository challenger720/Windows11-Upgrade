# Enable computer to restart whenever user sign out: 
Register-ScheduledTask -Xml (Get-Content "C:\Temp\restart.xml" | Out-String) -TaskName "ForceRestartOnLogoff"

# Remove the task above after upgrade:
Unregister-ScheduledTask -TaskName "ForceRestartOnLogoff" -Confirm:$false
