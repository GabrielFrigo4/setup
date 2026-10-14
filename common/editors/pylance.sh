#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Pylance Language Server Installation
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v pylance > "/dev/null" 2>&1 || python3 -c "import pylance" > "/dev/null" 2>&1; then
	_ui_ok "Pylance já está instalado."
	exit 0
fi

_ui_step "Instalando suporte ao Python Language Server (Pylance)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes devel/py-pylance 2> "/dev/null" || true
elif command -v pip3 > "/dev/null" 2>&1 || command -v pip > "/dev/null" 2>&1; then
	_pip="pip"
	command -v pip3 > "/dev/null" 2>&1 && _pip="pip3"
	${_pip} install --break-system-packages pylance 2> "/dev/null" || \
	${_pip} install pylance 2> "/dev/null" || \
	pipx install pylance 2> "/dev/null" || true
elif command -v python3 > "/dev/null" 2>&1; then
	python3 -m pip install --break-system-packages pylance 2> "/dev/null" || \
	python3 -m pip install pylance 2> "/dev/null" || true
elif command -v python > "/dev/null" 2>&1; then
	python -m pip install pylance 2> "/dev/null" || true
elif command -v py.exe > "/dev/null" 2>&1; then
	py.exe -m pip install pylance 2> "/dev/null" || true
fi

_ui_ok "Suporte ao Pylance configurado com sucesso!"
