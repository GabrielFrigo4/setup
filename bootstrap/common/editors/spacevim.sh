#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: SpaceVim Framework Complete Setup
# ------------------------------------------------------------------------------
set -eu

rm -rf "${HOME}/.vim" "${HOME}/.vimrc" "${HOME}/.SpaceVim" "${HOME}/.SpaceVim.d" 2> "/dev/null" || true

git clone "https://github.com/SpaceVim/SpaceVim.git" "${HOME}/.SpaceVim"
mkdir -p "${HOME}/.SpaceVim.d/autoload"

cat << 'EOF' | tee "${HOME}/.SpaceVim.d/init.toml" > "/dev/null"
[options]
   guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
   colorscheme = "onedark"
   colorscheme_bg = "dark"
   enable_statusline_mode = true
   statusline_separator = "arrow"
   enable_tabline_filetype_icon = true
   enable_bufferline = true
   bootstrap_before = "myspacevim#before"

[[layers]]
   name = "autocomplete"
   auto_completion_return_key_behavior = "complete"
   auto_completion_tab_key_behavior = "smart"

[[layers]]
   name = "shell"
   default_position = "bottom"
   default_height = 30

[[layers]]
   name = "git"

[[layers]]
   name = "lsp"
EOF

cat << 'EOF' | tee "${HOME}/.SpaceVim.d/autoload/myspacevim.vim" > "/dev/null"
function! myspacevim#before() abort
   let &t_SI = "\e[5 q"
   let &t_SR = "\e[3 q"
   let &t_EI = "\e[1 q"
   set guicursor+=n-v-c:blinkon1
   set guicursor+=i-ci:ver25-blinkon1
endfunction
EOF
