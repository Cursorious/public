REM Download Curl for windows first
@echo off

set class="not_available"
if "%2" == "Channel" (set class="No Signal")
if "%2" == "IP" (set class="Disconnected")
if "%2" == "Server" (set class="Problem")
if "%2" == "OperatorGUI" (set class="Sleeps")
REM if "%2" == "Template" (set class="State")

"C:\zabbix\4trassir\curl\bin\curl.exe" --silent --insecure https://localhost:8080/objects/%1?password=zabbix01D | find /c %class%