@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Ollama CLI (Winget) + Python SDK (pip)
rem ----------------------------------------------------------------

echo [*] Instalando o Ollama no Windows...
winget install -e --id Ollama.Ollama --accept-source-agreements --accept-package-agreements

echo.
echo [*] Instalando a biblioteca do Ollama no Python...
pip install ollama

echo.
echo [V] Tudo instalado (CLI nativo + pacote Python)!
endlocal
