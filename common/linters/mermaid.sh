#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Mermaid CLI & Filter Installation
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v mermaid-filter > "/dev/null" 2>&1 && command -v mmdc > "/dev/null" 2>&1; then
	_ui_ok "Mermaid CLI e mermaid-filter já instalados."
	exit 0
fi

_ui_step "Instalando runtime Node, mermaid-filter e @mermaid-js/mermaid-cli..."

if ! command -v node > "/dev/null" 2>&1 || ! command -v npm > "/dev/null" 2>&1; then
	if command -v pkg > "/dev/null" 2>&1; then
		${ELEVATE} pkg install --yes www/node www/npm
	elif command -v dnf > "/dev/null" 2>&1; then
		${ELEVATE} dnf install --assumeyes nodejs npm
	elif command -v apt > "/dev/null" 2>&1; then
		${ELEVATE} apt install --yes nodejs npm
	elif command -v pacman > "/dev/null" 2>&1; then
		${ELEVATE} pacman -S --needed --noconfirm nodejs npm
	fi
fi

if command -v npm > "/dev/null" 2>&1; then
	if ! command -v mermaid-filter > "/dev/null" 2>&1; then
		${ELEVATE} npm install --global mermaid-filter
	fi
	if ! command -v mmdc > "/dev/null" 2>&1; then
		${ELEVATE} npm install --global @mermaid-js/mermaid-cli
	fi
fi

_ui_ok "mermaid-filter e mmdc configurados com sucesso!"
