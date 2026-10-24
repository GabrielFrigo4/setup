#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common System & Console Terminus Fonts
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v fc-list > "/dev/null" 2>&1 && fc-list : family | grep -qi "terminus" 2> "/dev/null"; then
	_ui_ok "Fontes Terminus já instaladas no sistema."
	exit 0
fi

_ui_step "Instalando tipografia Terminus (console e TTF)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		x11-fonts/terminus-font \
		x11-fonts/terminus-ttf
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		terminus-fonts \
		terminus-fonts-console
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		xfonts-terminus \
		fonts-terminus \
		console-terminus 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		terminus-font
fi

if command -v fc-cache > "/dev/null" 2>&1; then
	fc-cache -f 2> "/dev/null" || true
fi

_ui_ok "Tipografia Terminus instalada com sucesso!"
