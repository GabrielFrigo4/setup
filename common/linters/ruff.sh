#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Ruff Python Linter & Formatter Installation
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v ruff > "/dev/null" 2>&1; then
	_ui_ok "Ruff CLI já está instalado."
	exit 0
fi

_ui_step "Instalando linter e formatador Python Ruff..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes devel/py-ruff 2> "/dev/null" || ${ELEVATE} pkg install --yes ruff
elif command -v dnf > "/dev/null" 2>&1; then
	if ! ${ELEVATE} dnf install --assumeyes ruff 2> "/dev/null"; then
		if command -v pipx > "/dev/null" 2>&1; then
			pipx install ruff
		elif command -v pip3 > "/dev/null" 2>&1; then
			pip3 install --break-system-packages ruff 2> "/dev/null" || pip3 install ruff
		fi
	fi
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	if ! ${ELEVATE} apt-get install --yes ruff 2> "/dev/null"; then
		if command -v pipx > "/dev/null" 2>&1; then
			pipx install ruff
		elif command -v pip3 > "/dev/null" 2>&1; then
			pip3 install --break-system-packages ruff 2> "/dev/null" || pip3 install ruff
		fi
	fi
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		if command -v winget.exe > "/dev/null" 2>&1; then
			winget.exe install --id AstralSoftware.Ruff --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
		elif command -v pip > "/dev/null" 2>&1; then
			pip install ruff 2> "/dev/null" || true
		fi
	else
		${ELEVATE} pacman -S --needed --noconfirm ruff
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id AstralSoftware.Ruff --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
elif command -v pipx > "/dev/null" 2>&1; then
	pipx install ruff
elif command -v pip3 > "/dev/null" 2>&1; then
	pip3 install --break-system-packages ruff 2> "/dev/null" || pip3 install ruff
elif command -v pip > "/dev/null" 2>&1; then
	pip install ruff 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes compatível não encontrado."
	exit 1
fi

_ui_ok "Ruff linter e formatador instalado com sucesso!"
