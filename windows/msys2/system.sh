#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: MSYS2 Base System Setup (UCRT64)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"

_ui_step "Configurando sistema base e shell padrão (MSYS2 UCRT64)..."

for _ini in /clang64.ini /clangarm64.ini /mingw64.ini /msys2.ini /ucrt64.ini; do
	if [ -f "${_ini}" ] && ! grep -qxF "SHELL=/usr/bin/bash" "${_ini}" 2> "/dev/null"; then
		echo "SHELL=/usr/bin/bash" >> "${_ini}"
	fi
done

pacman --needed --noconfirm -S \
	base-devel \
	binutils \
	coreutils \
	sys-utils \
	mingw-w64-cross-toolchain \
	mingw-w64-cross \
	git \
	git-crypt \
	make \
	cmake \
	openssh \
	net-utils \
	man-db \
	bash \
	zsh

_ui_ok "Sistema base MSYS2 configurado com sucesso!"
