@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Common Editors Configuration (Windows)
rem ----------------------------------------------------------------------------

echo [*] Configurando perfis de editores no Windows...

if not exist "%USERPROFILE%\.emacs.d\.git" (
	git clone "https://github.com/GabrielFrigo4/.emacs.d.git" "%USERPROFILE%\.emacs.d"
) else (
	git -C "%USERPROFILE%\.emacs.d" pull 2>nul
)

if not exist "%LOCALAPPDATA%\nvim\.git" (
	git clone "https://github.com/GabrielFrigo4/nvim.git" "%LOCALAPPDATA%\nvim"
) else (
	git -C "%LOCALAPPDATA%\nvim" pull 2>nul
)

if not exist "%USERPROFILE%\vimfiles\.git" (
	git clone "https://github.com/GabrielFrigo4/vimfiles.git" "%USERPROFILE%\vimfiles"
) else (
	git -C "%USERPROFILE%\vimfiles" pull 2>nul
)

(
echo set rtp+=~/vimfiles
echo source ~/vimfiles/vimrc
) > "%USERPROFILE%\_vimrc"

if not exist "%APPDATA%\helix\.git" (
	git clone "https://github.com/GabrielFrigo4/helix.git" "%APPDATA%\helix"
) else (
	git -C "%APPDATA%\helix" pull 2>nul
)

mkdir "%USERPROFILE%\.config\micro\colorschemes" 2>nul
curl -fsSL "https://raw.githubusercontent.com/dracula/micro/master/dracula.micro" -o "%USERPROFILE%\.config\micro\colorschemes\dracula.micro" 2>nul

(
echo {
echo 	"colorscheme": "dracula"
echo }
) > "%USERPROFILE%\.config\micro\settings.json"

echo [V] Perfis de editores configurados com sucesso!
endlocal
