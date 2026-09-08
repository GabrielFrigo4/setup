@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Chocolatey Package Manager & Packages
rem ----------------------------------------------------------------

powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

choco feature enable -n=allowGlobalConfirmation

rem --------------------------------
rem Debuggers
rem --------------------------------
choco install pestudio
choco install cheatengine

rem --------------------------------
rem Memory
rem --------------------------------
choco install dmde

choco feature disable -n=allowGlobalConfirmation
endlocal
