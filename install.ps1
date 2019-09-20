New-Item -ErrorAction Ignore -Path 'c:\temp' -ItemType Directory
Remove-Item -ErrorAction Ignore -Path C:\temp\install.cmd
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tkelder81/zabbix-agent/master/install.cmd" -OutFile "C:\temp\install.cmd"
cmd "/c C:\temp\install.cmd"
