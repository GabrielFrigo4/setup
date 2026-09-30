@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Collabora Office Desktop Suite (Windows)
rem ----------------------------------------------------------------

echo [*] Verificando gerenciador de pacotes do Windows (Winget)...

where winget >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [!] Erro: Winget nao encontrado no PATH do sistema.
    exit /b 1
)

echo [*] Instalando Collabora Office Desktop via Microsoft Store...

winget install 9P9MRBXJJG0M --accept-package-agreements --accept-source-agreements

if %ERRORLEVEL% equ 0 (
    echo [V] Collabora Office Desktop instalado com sucesso!
) else (
    echo [!] Aviso: Falha ou instalacao pendente do Collabora Office.
)

endlocal
