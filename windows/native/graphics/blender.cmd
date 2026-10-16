@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Blender 3D Suite (Windows)
rem ----------------------------------------------------------------

echo [*] Verificando gerenciador de pacotes do Windows (Winget)...

where winget >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [!] Erro: Winget nao encontrado no PATH do sistema.
    exit /b 1
)

echo [*] Instalando Blender 3D Suite via Winget...

winget install --id BlenderFoundation.Blender --accept-package-agreements --accept-source-agreements

if %ERRORLEVEL% equ 0 (
    echo [V] Blender 3D Suite instalado com sucesso!
) else (
    echo [!] Aviso: Falha ou instalacao pendente do Blender.
)

endlocal
