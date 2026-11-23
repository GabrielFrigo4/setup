@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: LibreOffice Productivity Suite (Windows)
rem ----------------------------------------------------------------

echo [*] Verificando instalacao do LibreOffice...

where soffice >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [V] LibreOffice ja instalado no PATH do sistema!
    exit /b 0
)

if exist "%ProgramFiles%\LibreOffice\program\soffice.exe" (
    echo [V] LibreOffice ja instalado em "%ProgramFiles%\LibreOffice\program\soffice.exe"!
    exit /b 0
)

if exist "%ProgramFiles(x86)%\LibreOffice\program\soffice.exe" (
    echo [V] LibreOffice ja instalado em "%ProgramFiles(x86)%\LibreOffice\program\soffice.exe"!
    exit /b 0
)

where winget >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [!] Erro: Winget nao encontrado no PATH do sistema.
    exit /b 1
)

echo [*] Instalando LibreOffice via Winget...
winget install --id TheDocumentFoundation.LibreOffice --accept-package-agreements --accept-source-agreements

if %ERRORLEVEL% equ 0 (
    echo [V] LibreOffice instalado com sucesso!
) else (
    echo [!] Aviso: Falha ou instalacao pendente do LibreOffice.
    exit /b 1
)

endlocal
