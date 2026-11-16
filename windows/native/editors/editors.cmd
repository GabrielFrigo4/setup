@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Common Editors Configuration (Windows)
rem ----------------------------------------------------------------

echo [*] Configurando perfis de editores no Windows...

if not exist "%USERPROFILE%\.emacs.d\.git" (
	git clone "https://github.com/GabrielFrigo4/emacs.git" "%USERPROFILE%\.emacs.d"
) else (
	git -C "%USERPROFILE%\.emacs.d" pull 2>nul
)

if not exist "%LOCALAPPDATA%\nvim\.git" (
	git clone "https://github.com/GabrielFrigo4/neovim.git" "%LOCALAPPDATA%\nvim"
) else (
	git -C "%LOCALAPPDATA%\nvim" pull 2>nul
)

if not exist "%USERPROFILE%\vimfiles\.git" (
	git clone "https://github.com/GabrielFrigo4/vim.git" "%USERPROFILE%\vimfiles"
) else (
	git -C "%USERPROFILE%\vimfiles" pull 2>nul
)

(
echo set rtp+=~/vimfiles
echo source ~/vimfiles/vimrc
) > "%USERPROFILE%\_vimrc"

if exist "%USERPROFILE%\vimfiles\" (
	if not exist "%USERPROFILE%\.vim\" (
		dir /a:l /b "%USERPROFILE%" 2>nul | findstr /i /l /x ".vim" >nul 2>&1 && rmdir "%USERPROFILE%\.vim" >nul 2>&1
		if not exist "%USERPROFILE%\.vim" (
			mklink /J "%USERPROFILE%\.vim" "%USERPROFILE%\vimfiles" >nul 2>&1
			if errorlevel 1 (
				echo [!] Aviso: falha ao criar junction "%USERPROFILE%\.vim".
			) else (
				echo [V] Junction "%USERPROFILE%\.vim" -^> "%USERPROFILE%\vimfiles" configurada!
			)
		) else (
			echo [!] Aviso: "%USERPROFILE%\.vim" ja existe como arquivo independente.
		)
	)
)

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
