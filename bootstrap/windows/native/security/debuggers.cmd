@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: x64dbg Plugin Manager & Plugins
rem ----------------------------------------------------------------------------

echo [*] Instalando x64dbg Plugin Manager e plugins...

for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/x64dbg-Plugin-Manager/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "X64PLG_VER=%%i"
if defined X64PLG_VER (
    wget -O "%TEMP%\x64plg.zip" "https://github.com/horsicq/x64dbg-Plugin-Manager/releases/download/%X64PLG_VER%/x64plgmnr_win32_portable_%X64PLG_VER%.zip"
    7z x "%TEMP%\x64plg.zip" -o"C:\Program Files\x64dbg-Plugin-Manager" -y
    if exist "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnr_win32_portable" (
        robocopy "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnr_win32_portable" "C:\Program Files\x64dbg-Plugin-Manager" /E /MOV >nul 2>nul
        rmdir /s /q "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnr_win32_portable" 2>nul
    )
    del "%TEMP%\x64plg.zip" 2>nul
    if exist "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnrc.exe" (
        "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnrc.exe" -U
        "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnrc.exe" -i stringsx64dbg
        "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnrc.exe" -i pex64dbg
        "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnrc.exe" -i nfdx64dbg
    )
)

endlocal
