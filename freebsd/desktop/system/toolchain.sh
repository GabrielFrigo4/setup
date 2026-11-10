#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Toolchain (GCC, Coreutils, CMake, Libtool)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if pkg info --exists gcc > "/dev/null" 2>&1 && \
	pkg info --exists coreutils > "/dev/null" 2>&1 && \
	pkg info --exists cmake > "/dev/null" 2>&1 && \
	pkg info --exists libtool > "/dev/null" 2>&1; then
	_ui_ok "GCC, GNU Coreutils, CMake e Libtool já instalados."
	exit 0
fi

_ui_step "Instalando GCC, GNU Coreutils, CMake e Libtool..."

${ELEVATE} pkg install -y \
	lang/gcc \
	sysutils/coreutils \
	devel/cmake \
	devel/cmake-core \
	devel/cmake-man \
	devel/cmake-gui \
	devel/libtool

_ui_ok "GCC, GNU Coreutils, CMake e Libtool instalados com sucesso!"
