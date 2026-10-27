#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: MongoDB NoSQL Document Database & Shell (mongosh)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v mongod > "/dev/null" 2>&1 || command -v mongosh > "/dev/null" 2>&1; then
	_ui_ok "MongoDB / mongosh já está instalado."
	exit 0
fi

_ui_step "Instalando MongoDB e MongoDB Shell..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes databases/mongodb70 2> "/dev/null" || \
		_ui_warn "Pacote mongodb70 ausente no espelho pkg atual."
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes mongodb-org 2> "/dev/null" || \
		_ui_info "MongoDB requer repositório externo mongodb-org ou container no Fedora."
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes mongodb-org 2> "/dev/null" || \
		_ui_info "MongoDB requer repositório externo mongodb-org ou container no Debian/Ubuntu."
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		_ui_info "No Windows/MSYS2, utilize winget ou scoop para instalar o MongoDB nativo."
	elif command -v yay > "/dev/null" 2>&1; then
		yay -S --needed --noconfirm mongodb-bin mongosh-bin 2> "/dev/null" || true
	else
		_ui_warn "Auxiliar AUR (yay) necessário para instalar mongodb-bin no Arch Linux."
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install mongosh
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install mongodb mongosh
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id MongoDB.Server --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id MongoDB.Shell --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Rotina do MongoDB concluída!"
