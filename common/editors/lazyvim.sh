#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: LazyVim Framework Complete Setup
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if [ -d "${HOME}/.config/nvim/lua/config" ] && [ -f "${HOME}/.config/nvim/lua/config/options.lua" ]; then
	_ui_ok "LazyVim já está configurado."
	exit 0
fi

_ui_step "Instalando e configurando LazyVim starter..."

rm -rf "${HOME}/.config/nvim" 2> "/dev/null" || true

git clone "https://github.com/LazyVim/starter" "${HOME}/.config/nvim"
rm -rf "${HOME}/.config/nvim/.git"

mkdir -p "${HOME}/.config/nvim/lua/config"

cat << 'EOF' | tee -a "${HOME}/.config/nvim/lua/config/options.lua" > "/dev/null"
local cursor_gui = vim.api.nvim_get_option_value("guicursor", {})
local cursor_group = vim.api.nvim_create_augroup('ConfigCursor', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
	group = cursor_group,
	pattern = '*',
	command = 'set guicursor=' .. cursor_gui .. ',a:blinkwait500-blinkoff500-blinkon500-Cursor/lCursor'
})
vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
	group = cursor_group,
	pattern = '*',
	command = 'set guicursor='
})
EOF

_ui_ok "LazyVim configurado com sucesso!"
