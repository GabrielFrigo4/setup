#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: MSYS2 Terminal Code Editors (UCRT64)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"

_ui_step "Instalando Emacs e Micro (MSYS2 UCRT64)..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-emacs \
	mingw-w64-ucrt-x86_64-emacs-pdf-tools-server \
	mingw-w64-ucrt-x86_64-micro

_ui_ok "Editores MSYS2 instalados com sucesso!"
