@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Binary Analysis Tools (Horsicq Suite)
rem ----------------------------------------------------------------------------

echo [*] Instalando utilitarios de analise de binarios Horsicq...

rem XPEViewer
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XPEViewer/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XPE_VER=%%i"
if defined XPE_VER (
    wget -O "%TEMP%\xpe.zip" "https://github.com/horsicq/XPEViewer/releases/download/%XPE_VER%/xpeviewer_win64_portable_%XPE_VER%_x64.zip"
    7z x "%TEMP%\xpe.zip" -o"C:\Program Files\XPEViewer" -y
    del "%TEMP%\xpe.zip" 2>nul
)

rem XELFViewer
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XELFViewer/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XELF_VER=%%i"
if defined XELF_VER (
    wget -O "%TEMP%\xelf.zip" "https://github.com/horsicq/XELFViewer/releases/download/%XELF_VER%/xelfviewer_win64_portable_%XELF_VER%.zip"
    7z x "%TEMP%\xelf.zip" -o"C:\Program Files\XELFViewer" -y
    del "%TEMP%\xelf.zip" 2>nul
)

rem XMachOViewer
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XMachOViewer/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XMACHO_VER=%%i"
if defined XMACHO_VER (
    wget -O "%TEMP%\xmacho.zip" "https://github.com/horsicq/XMachOViewer/releases/download/%XMACHO_VER%/xmachoviewer_win64_portable_%XMACHO_VER%.zip"
    7z x "%TEMP%\xmacho.zip" -o"C:\Program Files\XMachOViewer" -y
    del "%TEMP%\xmacho.zip" 2>nul
)

rem XAPKDetector
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XAPKDetector/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XAPK_VER=%%i"
if defined XAPK_VER (
    wget -O "%TEMP%\xapk.zip" "https://github.com/horsicq/XAPKDetector/releases/download/%XAPK_VER%/xapkdetector_win64_portable_%XAPK_VER%.zip"
    7z x "%TEMP%\xapk.zip" -o"C:\Program Files\XAPKDetector" -y
    del "%TEMP%\xapk.zip" 2>nul
)

rem XOpcodeCalc
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XOpcodeCalc/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XOP_VER=%%i"
if defined XOP_VER (
    wget -O "%TEMP%\xop.zip" "https://github.com/horsicq/XOpcodeCalc/releases/download/%XOP_VER%/xopcodecalc_win64_portable_%XOP_VER%.zip"
    7z x "%TEMP%\xop.zip" -o"C:\Program Files\XOpCode" -y
    del "%TEMP%\xop.zip" 2>nul
)

endlocal
