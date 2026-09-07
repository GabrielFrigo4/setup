@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Common Developer Tools & Linters Configuration (Windows)
rem ----------------------------------------------------------------------------

echo [*] Configurando formatadores e linters globais no Windows...

set "SCRIPT_DIR=%~dp0"
set "LOCAL_TOOLS_DIR=%SCRIPT_DIR%..\..\..\..\software\tools"
set "RAW_BASE_URL=https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/software/tools"

mkdir "%LOCALAPPDATA%\clangd" 2>nul

call :sync_file ".clang-format" "%USERPROFILE%\.clang-format"
call :sync_file "clangd.yaml" "%LOCALAPPDATA%\clangd\config.yaml"
call :sync_file ".prettierrc" "%USERPROFILE%\.prettierrc"
call :sync_file ".stylua.toml" "%USERPROFILE%\.stylua.toml"
call :sync_file "mermaid-puppeteer.json" "%USERPROFILE%\.mermaid-puppeteer-config.json"
call :sync_file "mermaid-theme.json" "%USERPROFILE%\.mermaid-theme-config.json"

echo [+] Formatadores (.clang-format, clangd, prettier, stylua, mermaid) configurados com sucesso!
goto :eof

:sync_file
set "SRC_NAME=%~1"
set "DEST_PATH=%~2"
set "LOCAL_FILE=%LOCAL_TOOLS_DIR%\%SRC_NAME%"
set "RAW_URL=%RAW_BASE_URL%/%SRC_NAME%"

if exist "%LOCAL_FILE%" (
    copy /y "%LOCAL_FILE%" "%DEST_PATH%" >nul
) else (
    curl.exe -fsSL "%RAW_URL%" -o "%DEST_PATH%"
)
goto :eof
