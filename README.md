Upgrade a computer to Windows 11 with no auto reboot:
1. Copy the Win11_24H2_English_x64.iso file and Win11Upgrade.ps1 to C:\Temp  
2. Run the command to execute the Win11Upgrade.ps1 in Powershell (e.g. Powershell in Endpoint)
3. Check Win11UpgradeLog.txt for upgrade status
4. Reboot after Win11UpgradeLog.txt writes "Upgrade script completed. Awaiting user reboot."

Important notes:
- Do not rename the files, otherwise you have to edit the path in Win11Upgrade.ps1
- Computer can be unattended, but must be login by any user 
- User must RESTART after upgrade script completed (NOT SIGN OUT / SHUTDOWN)
- User must not sign out during upgrade / before user reboot after upgrade script completed, otherwise upgrade will be cancelled
- To enable auto reboot, edit Line 15 in Win11Upgrade.ps1 to ArgumentList "/auto upgrade /quiet /dynamicupdate disable /eula accept" `
(Also edit the value in Line 32 to "Starting silent upgrade with auto reboot...")

To force restart when user sign out:
- Copy restart.xml to C:\Temp (Do not rename the xml)
- Refer to Force restart when log off - Task register.txt:
-> Run PowerShell command to Register Scheduled task
-> After the upgrade, remember to run PowerShell command to Unregister Scheduled Task, otherwise computer will restart every time user sign out 
