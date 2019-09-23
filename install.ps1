New-Item -ErrorAction Ignore -Path 'c:\temp' -ItemType Directory
New-Item -ErrorAction Ignore -Path 'c:\temp\zabbix' -ItemType Directory
Invoke-WebRequest -Uri "https://www.zabbix.com/downloads/4.2.6/zabbix_agents-4.2.6-win-i386-openssl.zip" -OutFile "C:\temp\zabbix_agents-4.2.6-win-i386-openssl.zip"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tkelder81/zabbix-agent/master/install.cmd" -OutFile "C:\temp\install.cmd"
Expand-Archive -Force C:\temp\zabbix_agents-4.2.6-win-i386-openssl.zip C:\temp\zabbix
cmd "/c C:\temp\install.cmd"
Remove-Item -ErrorAction Ignore -Path C:\temp\install.cmd
