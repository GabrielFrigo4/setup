@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Scoop Package Manager & Curated Packages
rem ----------------------------------------------------------------------------

pwsh -Command "Invoke-RestMethod get.scoop.sh | Invoke-Expression"

scoop bucket add nonportable
scoop bucket add extras
scoop bucket add main
scoop bucket add nerd-fonts
scoop bucket add java

scoop install grex pstools innounp winfetch winchecksec explorer-suite resource-hacker
scoop install coreutils uutils-coreutils binutils
scoop install stylua gopls nano sed
scoop install openjdk oraclejre8 digital ghidra
scoop install fasm fasmg fasmarm

endlocal
