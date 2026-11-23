@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Windows Python 3.14 Stack (TUI, GUI, Vision & Docs)
rem ----------------------------------------------------------------

echo [*] Verificando runtime Python e utilitario uv...

rem --------------------------------
rem PYTHON RUNTIME
rem --------------------------------
set "PY_CMD="
python -c "import sys" >nul 2>&1 && set "PY_CMD=python"
if not defined PY_CMD py -3 -c "import sys" >nul 2>&1 && set "PY_CMD=py -3"

if not defined PY_CMD (
    where winget >nul 2>&1
    if errorlevel 1 (
        echo [!] Erro: Python e Winget nao encontrados no PATH do sistema.
        exit /b 1
    )
    echo [*] Instalando Python 3.14 via Winget...
    winget install --id Python.Python.3.14 --accept-package-agreements --accept-source-agreements
    set "PY_CMD=py -3"
)

where uv >nul 2>&1
if errorlevel 1 (
    where winget >nul 2>&1 && winget install --id astral-sh.uv --accept-package-agreements --accept-source-agreements
)

rem --------------------------------
rem PYTHON PACKAGES
rem --------------------------------
echo [*] Sincronizando pacotes Python com %PY_CMD%...
%PY_CMD% -m pip install --upgrade pip >nul 2>&1
%PY_CMD% -m pip install --upgrade PyQt6 rich textual opencv-python-headless numpy Pillow python-docx tqdm ollama

%PY_CMD% -c "import PyQt6, rich, textual, cv2, numpy, PIL, docx, tqdm, ollama" >nul 2>&1
if errorlevel 1 (
    echo [!] Aviso: Falha ou instalacao pendente em um ou mais modulos Python.
    exit /b 1
)

echo [V] Stack Python completa instalada e validada com sucesso!
endlocal
