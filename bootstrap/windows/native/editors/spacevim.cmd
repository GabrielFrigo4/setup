@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: SpaceVim Framework Complete Setup (Windows)
rem ----------------------------------------------------------------------------

rmdir /s /q "%USERPROFILE%\.vim" 2>nul
del /q "%USERPROFILE%\_vimrc" 2>nul
rmdir /s /q "%USERPROFILE%\.SpaceVim" 2>nul
rmdir /s /q "%USERPROFILE%\.SpaceVim.d" 2>nul

git clone "https://github.com/SpaceVim/SpaceVim.git" "%USERPROFILE%\.SpaceVim"
mkdir "%USERPROFILE%\.SpaceVim.d\autoload" 2>nul

(
echo [options]
echo    guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
echo    colorscheme = "onedark"
echo    colorscheme_bg = "dark"
echo    enable_statusline_mode = true
echo    statusline_separator = "arrow"
echo    enable_tabline_filetype_icon = true
echo    enable_bufferline = true
echo    bootstrap_before = "myspacevim#before"
echo.
echo [[layers]]
echo    name = "autocomplete"
echo    auto_completion_return_key_behavior = "complete"
echo    auto_completion_tab_key_behavior = "smart"
echo.
echo [[layers]]
echo    name = "shell"
echo    default_position = "bottom"
echo    default_height = 30
echo.
echo [[layers]]
echo    name = "git"
echo.
echo [[layers]]
echo    name = "lsp"
) > "%USERPROFILE%\.SpaceVim.d\init.toml"

(
echo function! myspacevim#before(^) abort
echo    let ^^&t_SI = "\e[5 q"
echo    let ^^&t_SR = "\e[3 q"
echo    let ^^&t_EI = "\e[1 q"
echo    set guicursor+=n-v-c:blinkon1
echo    set guicursor+=i-ci:ver25-blinkon1
echo endfunction
) > "%USERPROFILE%\.SpaceVim.d\autoload\myspacevim.vim"

endlocal
