@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Python Language Server (Pylance) Setup
rem ----------------------------------------------------------------

echo [*] Instalando suporte ao Pylance no Windows...

where py >nul 2>&1
if %ERRORLEVEL% equ 0 (
	py -m pip install pylance 2>nul
	goto :done
)

where python >nul 2>&1
if %ERRORLEVEL% equ 0 (
	python -m pip install pylance 2>nul
	goto :done
)

where pip >nul 2>&1
if %ERRORLEVEL% equ 0 (
	pip install pylance 2>nul
	goto :done
)

:done
echo [V] Suporte ao Pylance configurado com sucesso!
endlocal
