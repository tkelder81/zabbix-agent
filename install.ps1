New-Item -ErrorAction Ignore -Path 'c:\temp' -ItemType Directory
New-Item -Path 'c:\temp' -ItemType Directory
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tkelder81/zabbix-agent/master/install.cmd" -OutFile "C:\temp\install.cmd"
Start-Process "cmd.exe"  "/c C:\temp\install.cmd"
