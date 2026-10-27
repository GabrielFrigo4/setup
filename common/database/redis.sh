#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Redis In-Memory Key-Value Data Store
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v redis-cli > "/dev/null" 2>&1 || command -v valkey-cli > "/dev/null" 2>&1; then
	_ui_ok "Redis / Valkey já está instalado."
	exit 0
fi

_ui_step "Instalando Redis..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes databases/redis
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes redis
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes redis-server
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		_ui_info "Para Redis no Windows, utilize winget, scoop ou containers."
	else
		${ELEVATE} pacman -S --needed --noconfirm redis
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install redis
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install redis
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Redis.Redis --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Redis instalado com sucesso!"
