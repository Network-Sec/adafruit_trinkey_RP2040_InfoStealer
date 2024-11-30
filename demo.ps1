systeminfo
tasklist
netstat -ano | Select-String "TCP|UDP" | ForEach-Object { $columns = $_ -split '\s+'; $processId = $columns[-1]; $proc = Get-Process -Id $processId -ErrorAction SilentlyContinue; "$($_) $(if ($proc) { $proc.Name } else { 'Unknown' })" }
whoami /all
net user
net localgroup
Get-NetAdapter
ipconfig /all
ipconfig /displaydns
route print
arp -a
net share
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /s
Get-PSDrive -PSProvider FileSystem
Get-ChildItem Env:
Get-ChildItem
Get-ScheduledTask
cmdkey /list
