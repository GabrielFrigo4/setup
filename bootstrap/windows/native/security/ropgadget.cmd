@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: ROPgadget Executable Wrapper
rem ----------------------------------------------------------------------------

echo [*] Configurando wrapper ROPgadget...

pip install ropgadget

for /f "tokens=*" %%i in ('python -c "import sys, os; print(os.path.join(sys.prefix, 'Scripts'))"') do set "PYTHON_SCRIPTS=%%i"

if defined PYTHON_SCRIPTS (
    mkdir "%PYTHON_SCRIPTS%" 2>nul
    echo @echo off > "%PYTHON_SCRIPTS%\ROPgadget.cmd"
    echo python "%%~dp0ROPgadget" %%* >> "%PYTHON_SCRIPTS%\ROPgadget.cmd"
    echo [V] Wrapper criado em: %PYTHON_SCRIPTS%\ROPgadget.cmd
) else (
    echo [!] Nao foi possivel detectar o diretorio Scripts do Python.
)
endlocal
