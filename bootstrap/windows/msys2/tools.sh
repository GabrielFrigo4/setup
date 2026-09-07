#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 Modern CLI Tools (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 Tools]: Instalando utilitários modernos de linha de comando..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-uutils-coreutils \
	mingw-w64-ucrt-x86_64-git \
	mingw-w64-ucrt-x86_64-git-credential-wincred \
	mingw-w64-ucrt-x86_64-github-cli \
	mingw-w64-ucrt-x86_64-fd \
	mingw-w64-ucrt-x86_64-dust \
	mingw-w64-ucrt-x86_64-bat \
	mingw-w64-ucrt-x86_64-eza \
	mingw-w64-ucrt-x86_64-ripgrep \
	mingw-w64-ucrt-x86_64-repgrep \
	mingw-w64-ucrt-x86_64-fastfetch \
	mingw-w64-ucrt-x86_64-imagemagick \
	mingw-w64-ucrt-x86_64-ffmpeg

echo "✅ [MSYS2 Tools]: Utilitários instalados com sucesso!"
