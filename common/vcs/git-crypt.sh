#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Git-Crypt Transparent Git Encryption Tool
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v git-crypt > "/dev/null" 2>&1; then
	_ui_ok "git-crypt já está instalado."
	exit 0
fi

_ui_step "Instalando git-crypt..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes security/git-crypt
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes git-crypt
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm git-crypt
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq
	${ELEVATE} apt-get install --yes git-crypt
elif command -v brew > "/dev/null" 2>&1; then
	brew install git-crypt
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install git-crypt
else
	_ui_warn "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "git-crypt instalado com sucesso!"
