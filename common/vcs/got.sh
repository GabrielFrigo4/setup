#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Game of Trees (Got) Configuration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

GOT_CONF="${HOME}/.gotconfig"

if [ -f "${GOT_CONF}" ]; then
	_ui_ok "Arquivo ~/.gotconfig já configurado."
	exit 0
fi

_ui_step "Configurando Game of Trees (Got)..."

if [ -n "${GIT_AUTHOR_NAME-}" ] && [ -n "${GIT_AUTHOR_EMAIL-}" ]; then
	cat <<- EOF > "${GOT_CONF}"
	author "${GIT_AUTHOR_NAME} <${GIT_AUTHOR_EMAIL}>"
	EOF
	chmod 0644 "${GOT_CONF}"
	_ui_ok "Arquivo ~/.gotconfig configurado com sucesso!"
else
	_ui_warn "Variáveis GIT_AUTHOR_NAME ou GIT_AUTHOR_EMAIL não definidas."
fi

if command -v got > "/dev/null" 2>&1; then
	_ui_ok "Binário 'got' disponível no PATH."
else
	_ui_info "Binário 'got' ainda não instalado (disponível via 'pkg install devel/got' ou 'yay -S got-portable')."
fi
