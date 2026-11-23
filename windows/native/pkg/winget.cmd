@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Declarative Winget Package Import & Core Toolchain Pin
rem ----------------------------------------------------------------

where winget >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [!] Erro: winget nao encontrado no PATH do sistema.
    exit /b 1
)

echo [*] Importando pacotes declarativos de winget.json...
winget import -i "%~dp0winget.json" --accept-package-agreements --accept-source-agreements
if %ERRORLEVEL% neq 0 (
    echo [!] Aviso: winget import finalizou com avisos ou instalacoes pendentes.
)

echo [*] Fixando toolchains criticos...
winget pin add --id MSYS2.MSYS2 >nul 2>&1
winget pin add --id Nvidia.CUDA >nul 2>&1
winget pin add --id Python.Python.3.14 >nul 2>&1
winget pin add --id Microsoft.VisualStudio.Community >nul 2>&1
winget pin add --id Microsoft.VisualStudio.BuildTools >nul 2>&1
winget pin add --id ZedIndustries.Zed >nul 2>&1

echo [V] Provisionamento declarativo via Winget concluido!
endlocal
