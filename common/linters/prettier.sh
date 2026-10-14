#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Prettier CLI Formatter Installation
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v prettier > "/dev/null" 2>&1; then
	_ui_ok "Prettier CLI já está instalado."
	exit 0
fi

_ui_step "Instalando runtime Node e Prettier global..."

if ! command -v node > "/dev/null" 2>&1 || ! command -v npm > "/dev/null" 2>&1; then
	if command -v pkg > "/dev/null" 2>&1; then
		${ELEVATE} pkg install --yes www/node www/npm
	elif command -v dnf > "/dev/null" 2>&1; then
		${ELEVATE} dnf install --assumeyes nodejs npm
	elif command -v apt > "/dev/null" 2>&1; then
		${ELEVATE} apt install --yes nodejs npm
	elif command -v pacman > "/dev/null" 2>&1; then
		${ELEVATE} pacman -S --needed --noconfirm prettier 2> "/dev/null" || ${ELEVATE} pacman -S --needed --noconfirm nodejs npm
	fi
fi

if ! command -v prettier > "/dev/null" 2>&1 && command -v npm > "/dev/null" 2>&1; then
	${ELEVATE} npm install --global prettier
fi

_ui_ok "Prettier configurado com sucesso!"
