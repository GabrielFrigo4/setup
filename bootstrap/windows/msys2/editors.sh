#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 Terminal Code Editors (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 Editors]: Instalando Emacs e Micro (UCRT64)..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-emacs \
	mingw-w64-ucrt-x86_64-emacs-pdf-tools-server \
	mingw-w64-ucrt-x86_64-micro

echo "✅ [MSYS2 Editors]: Editores instalados com sucesso!"
