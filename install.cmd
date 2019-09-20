@echo off
echo "Welcome to the Advisor Zabbix Installation script"
echo.
if not exist ping.exe goto NotAnAdministrator
echo.

set /P hostname=Please enter the Hostname as configured in Zabbix:
choice /m "Is this server a RDS host"
if errorlevel 1 set rds=N
if errorlevel 0 set rds=Y

choice /m "Are you using a Zabbix Proxy"
if errorlevel 1 set proxy=N
if errorlevel 0 set proxy=Y
if /I "%proxy%" EQU "Y" set /P proxyip=Please enter the Zabbix Proxy IP address:


Echo "Removing the old Zabbix Client"
Sc stop "Zabbix Agent"
c:\zabbix\zabbix_agentd.exe --uninstall
Rmdir /Q c:\Zabbix

Echo "Installing new Zabbix Agent"
choco install zabbix-agent


Echo "Creating config file"
Sc stop "Zabbix Agent"
echo LogFile=c:\zabbix\zabbix_agentd.log>c:\zabbix\zabbix_agentd.win.conf
echo Hostname=%hostname%>>c:\zabbix\zabbix_agentd.win.conf

if /I "%proxyip% NOT == [] GOTO ADDPROXY
GOTO ADDNOPROXY

:RDSQuestion
if /I "%rds%" EQU "Y" GOTO ADDRDS
GOTO installservice

:ADDPROXY
@echo Server=%proxyip%>>c:\zabbix\zabbix_agentd.win.conf
@echo ServerActive=%proxyip%>>c:\zabbix\zabbix_agentd.win.conf
GOTO RDSQuestion

:ADDNOPROXY
@echo Server=10.255.255.21>>c:\zabbix\zabbix_agentd.win.conf
@echo ServerActive=10.255.255.21>>c:\zabbix\zabbix_agentd.win.conf
GOTO RDSQuestion

:ADDRDS
echo EnableRemoteCommands=1>%ProgramData%\zabbix\zabbix_agentd.win.conf 
echo UnsafeUserParameters=1>%ProgramData%\zabbix\zabbix_agentd.win.conf
echo "UserParameter=drainmode,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Zabbix\checkdrainmode.ps1">c:\zabbix\zabbix_agentd.win.conf
goto startservice

:installservice
net start "Zabbix Agent"

echo "Installation complete. Please check if the host comes online in Zabbix (could take about 5 minutes)"

:NotAnAdministrator
echo Please run this script as an administrator
echo.
pause
goto end

:end
