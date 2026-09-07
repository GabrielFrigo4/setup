@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Chocolatey Package Manager & Packages
rem ----------------------------------------------------------------------------

powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

rem Enable Auto Confirmation

choco feature enable -n=allowGlobalConfirmation

rem Install Choco Packages

rem --------------------------------
rem debuger
rem --------------------------------
choco install pestudio
choco install cheatengine

rem --------------------------------
rem memory
rem --------------------------------
choco install dmde

rem Disable Auto Confirmation

choco feature disable -n=allowGlobalConfirmation
endlocal
