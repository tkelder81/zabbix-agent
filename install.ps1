Set-ExecutionPolicy Bypass -Scope Process -Force
New-Item -Path 'c:\temp' -ItemType Directory
Invoke-WebRequest -Uri "https://github.com/tkelder81/zabbix-agent/install.cmd" -OutFile "C:\temp\install.cmd"
