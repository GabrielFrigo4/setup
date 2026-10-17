#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Ubuntu Server Baseline Provisioning
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Provisionando baseline de servidor Ubuntu..."

if ! command -v apt > "/dev/null" 2>&1; then
	_ui_err "Gerenciador de pacotes apt não encontrado. Esta receita é exclusiva para Ubuntu/Debian."
	exit 1
fi

${ELEVATE} apt update
${ELEVATE} apt install --yes apt-clone tmux

_ui_ok "Servidor Ubuntu provisionado com sucesso (apt-clone e tmux)!"
