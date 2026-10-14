#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common Web Browsers (Firefox + Chromium)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v firefox > "/dev/null" 2>&1 && { command -v chromium > "/dev/null" 2>&1 || command -v chromium-browser > "/dev/null" 2>&1; }; then
	_ui_ok "Navegadores (Firefox e Chromium) já instalados."
	exit 0
fi

_ui_step "Instalando Firefox e Chromium..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes www/firefox www/chromium
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes firefox chromium
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes firefox chromium 2> "/dev/null" || ${ELEVATE} apt install --yes firefox-esr chromium 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman --sync --needed --noconfirm firefox chromium
fi

_ui_ok "Firefox e Chromium instalados com sucesso!"
