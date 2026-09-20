@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Git Global Configuration (Windows)
rem ----------------------------------------------------------------

echo [*] Configurando Oh-My-Posh no PowerShell...
oh-my-posh init pwsh --config "$HOME/.oh-my-posh/themes/atomic.omp.json" > "$HOME/.oh-my-posh.ps1"

echo [*] Configurando Oh-My-Posh no Nushell...
oh-my-posh init nu --config "$HOME/.oh-my-posh/themes/atomic.omp.json" > "$HOME/.oh-my-posh.nu"

echo [Oh-My-Posh]: Configuracao global concluida com sucesso.
endlocal
