#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 Base System Setup (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 System]: Configurando sistema base e shell padrão..."

cat << 'EOF' | tee -a "/clang64.ini" | tee -a "/clangarm64.ini" | tee -a "/mingw32.ini" | tee -a "/mingw64.ini" | tee -a "/msys2.ini" | tee -a "/ucrt64.ini" > "/dev/null"
SHELL=/usr/bin/bash
EOF

pacman --needed --noconfirm -S \
	base-devel \
	binutils \
	coreutils \
	sys-utils \
	mingw-w64-cross-toolchain \
	mingw-w64-cross \
	git \
	make \
	cmake \
	openssh \
	net-utils \
	man-db \
	bash \
	zsh

echo "✅ [MSYS2 System]: Sistema base configurado com sucesso!"
