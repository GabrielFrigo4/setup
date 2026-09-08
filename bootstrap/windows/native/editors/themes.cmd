@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Editor Themes & Autoloaders
rem ----------------------------------------------------------------

echo [*] Instalando temas e complementos de editores...

mkdir "%APPDATA%\geany\colorschemes" 2>nul
curl -sL -o "%APPDATA%\geany\colorschemes\one-dark.conf" "https://raw.githubusercontent.com/geany/geany-themes/master/colorschemes/one-dark.conf"

mkdir "%USERPROFILE%\vimfiles\autoload" 2>nul
curl -sL -o "%USERPROFILE%\vimfiles\autoload\plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

echo [V] Temas e complementos configurados com sucesso!
endlocal
