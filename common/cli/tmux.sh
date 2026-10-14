#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Tmux Terminal Multiplexer
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v tmux > "/dev/null" 2>&1; then
	_ui_ok "Multiplexador tmux já está instalado."
	exit 0
fi

_ui_step "Instalando o multiplexador de terminal tmux..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes sysutils/tmux
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes tmux
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes tmux
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S tmux
	else
		${ELEVATE} pacman -S --needed --noconfirm tmux
	fi
elif command -v apk > "/dev/null" 2>&1; then
	${ELEVATE} apk add --no-cache tmux
elif command -v xbps-install > "/dev/null" 2>&1; then
	${ELEVATE} xbps-install -Sy tmux
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id tmux.tmux --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Multiplexador tmux instalado com sucesso!"
