@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Ghidra SRE (NSA)
rem ----------------------------------------------------------------------------

echo [*] Baixando Ghidra...
for /f "tokens=1,2" %%i in ('curl -sL "https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest" ^| findstr "browser_download_url.*ghidra_.*_PUBLIC_.*\.zip" ^| sed "s/.*ghidra_\([0-9.]*\)_PUBLIC_\([0-9]*\)\.zip.*/\1 \2/"') do (
    set "GHIDRA_VER=%%i"
    set "GHIDRA_DATE=%%j"
    goto :ghidra_download
)
:ghidra_download
if defined GHIDRA_VER (
    wget -O "%TEMP%\ghidra.zip" "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_%GHIDRA_VER%_build/ghidra_%GHIDRA_VER%_PUBLIC_%GHIDRA_DATE%.zip"
    7z x "%TEMP%\ghidra.zip" -o"C:\Program Files" -y
    if exist "C:\Program Files\ghidra_%GHIDRA_VER%_PUBLIC" (
        rmdir /s /q "C:\Program Files\GHIDRA" 2>nul
        ren "C:\Program Files\ghidra_%GHIDRA_VER%_PUBLIC" "GHIDRA"
    )
    del "%TEMP%\ghidra.zip" 2>nul
)

endlocal
