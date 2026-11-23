@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Scoop Package Manager & Curated Packages
rem ----------------------------------------------------------------

where scoop >nul 2>&1
if errorlevel 1 (
    echo [*] Instalando Scoop Package Manager...
    pwsh -Command "Invoke-RestMethod get.scoop.sh | Invoke-Expression"
)

for %%b in (nonportable extras main nerd-fonts java) do (
    scoop bucket add %%b >nul 2>&1
)

scoop install grex pstools innounp winfetch winchecksec explorer-suite resource-hacker
scoop install coreutils uutils-coreutils binutils
scoop install stylua gopls nano sed emscripten
scoop install openjdk oraclejre8 digital ghidra
scoop install fasm fasmg fasmarm

echo [V] Scoop e pacotes portateis configurados com sucesso!
endlocal
