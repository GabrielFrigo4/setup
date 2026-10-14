@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Oh-My-Posh Binary Installation (Windows)
rem ----------------------------------------------------------------

echo [*] Instalando Oh-My-Posh via Winget...
winget install JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements

echo [Oh-My-Posh]: Instalacao do binario concluida com sucesso.
endlocal
