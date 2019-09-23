@echo off
echo.
echo Welcome to the Advisor Zabbix Installation script
echo.
if not exist ping.exe goto NotAnAdministrator

set /P hostname=Please enter the Hostname as configured in Zabbix:
choice /m "Is this server a RDS host"
if errorlevel 1 set rds=N
if errorlevel 0 set rds=Y

choice /m "Are you using a Zabbix Proxy"
if errorlevel 1 set proxy=N
if errorlevel 0 set proxy=Y
if /I %proxy% EQU Y set /P proxyip=Please enter the Zabbix Proxy IP address:

echo "Removing the old Zabbix Client"
sc stop "Zabbix Agent"
c:\zabbix\zabbix_agentd.exe --uninstall
rmdir /Q c:\Zabbix

echo Installing new Zabbix Agent
md c:\zabbix
copy c:\temp\zabbix\bin\*.* c:\zabbix

Echo Creating config fil"
echo LogFile=c:\zabbix\zabbix_agentd.log>c:\zabbix\zabbix_agentd.win.conf
echo Hostname=%hostname%>>c:\zabbix\zabbix_agentd.win.conf

if /I "%proxyip% NOT == [] GOTO ADDPROXY
GOTO ADDNOPROXY

:ADDPROXY
echo Server=%proxyip%>>c:\zabbix\zabbix_agentd.win.conf
echo ServerActive=%proxyip%>>c:\zabbix\zabbix_agentd.win.conf
GOTO RDSQuestion

:ADDNOPROXY
echo Server=10.255.255.21>>c:\zabbix\zabbix_agentd.win.conf
echo ServerActive=10.255.255.21>>c:\zabbix\zabbix_agentd.win.conf
GOTO RDSQuestion

:RDSQuestion
if /I "%rds%" EQU "Y" GOTO ADDRDS
GOTO installservice

:ADDRDS
echo EnableRemoteCommands=1>%ProgramData%\zabbix\zabbix_agentd.win.conf 
echo UnsafeUserParameters=1>%ProgramData%\zabbix\zabbix_agentd.win.conf
echo UserParameter=drainmode,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Zabbix\checkdrainmode.ps1">c:\zabbix\zabbix_agentd.win.conf
goto installservice

:installservice
c:\zabbix\zabbix_agentd.exe --config c:\zabbix\zabbix_agentd.win.conf --install
net start "Zabbix Agent"
echo Removing temp files
del /q /s c:\temp\zabbix
del /q c:\temp\install.cmd
del /q c:\temp\zabbix_agents-4.2.6-win-i386-openssl.zip
goto end

:NotAnAdministrator
echo Please run this script as an administrator
goto end

:end
echo Installation complete. Please check if the host comes online in Zabbix (could take about 5 minutes)
