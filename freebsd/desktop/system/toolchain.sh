#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Build Toolchain (GCC, Coreutils & CMake)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if pkg info --exists gcc > "/dev/null" 2>&1 && \
	pkg info --exists coreutils > "/dev/null" 2>&1 && \
	pkg info --exists cmake > "/dev/null" 2>&1; then
	_ui_ok "GCC, GNU Coreutils e CMake já instalados."
	exit 0
fi

_ui_step "Instalando GCC, GNU Coreutils e CMake..."

${ELEVATE} pkg install --yes \
	lang/gcc \
	sysutils/coreutils \
	devel/cmake \
	devel/cmake-core \
	devel/cmake-man \
	devel/cmake-gui

_ui_ok "GCC, GNU Coreutils e CMake instalados com sucesso!"
