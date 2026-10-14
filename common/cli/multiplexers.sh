#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Terminal Multiplexers Suite (Tmux & Zellij)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v tmux > "/dev/null" 2>&1 && command -v zellij > "/dev/null" 2>&1; then
	_ui_ok "Multiplexadores de terminal (tmux e zellij) já instalados."
	exit 0
fi

_ui_step "Provisionando suite de multiplexadores de terminal..."

_dir="$(cd "$(dirname "$0")" && pwd)"

if [ -f "${_dir}/tmux.sh" ]; then
	sh "${_dir}/tmux.sh"
fi

if [ -f "${_dir}/zellij.sh" ]; then
	sh "${_dir}/zellij.sh"
fi

_ui_ok "Suite de multiplexadores provisionada com sucesso!"
