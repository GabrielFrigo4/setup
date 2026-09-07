@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Hyper-V Package Enablement
rem ----------------------------------------------------------------------------

pushd "%~dp0"

dir /b "%SystemRoot%\servicing\Packages\*Hyper-V*.mum" > "%TEMP%\hyper-v.txt" 2>nul
for /f "usebackq delims=" %%i in ("%TEMP%\hyper-v.txt") do (
    dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
)
del "%TEMP%\hyper-v.txt" 2>nul

dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL

popd
endlocal
