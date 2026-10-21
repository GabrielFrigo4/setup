#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD GNU Toolchain (GCC & Coreutils)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if pkg info --exists gcc > "/dev/null" 2>&1 && pkg info --exists coreutils > "/dev/null" 2>&1; then
	_ui_ok "GCC e GNU Coreutils já instalados."
	exit 0
fi

_ui_step "Instalando GCC e GNU Coreutils..."

${ELEVATE} pkg install --yes \
	lang/gcc \
	sysutils/coreutils

_ui_ok "GCC e GNU Coreutils instalados com sucesso!"
