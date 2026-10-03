#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common Web Browsers (Firefox + Chromium)
# ----------------------------------------------------------------
set -eu

_ui_step() { printf '[Common Browsers] %s\n' "$1"; }
_ui_ok()   { printf '[Common Browsers] %s\n' "$1"; }

_ui_step "Instalando Firefox e Chromium..."

if command -v pkg > "/dev/null" 2>&1; then
	ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"
	${ELEVATE} pkg install --yes firefox chromium
elif command -v dnf > "/dev/null" 2>&1; then
	sudo dnf install --assumeyes firefox chromium
elif command -v apt > "/dev/null" 2>&1; then
	sudo apt install --yes firefox chromium
elif command -v pacman > "/dev/null" 2>&1; then
	sudo pacman --sync --needed --noconfirm firefox chromium
fi

_ui_ok "Firefox e Chromium instalados com sucesso!"
