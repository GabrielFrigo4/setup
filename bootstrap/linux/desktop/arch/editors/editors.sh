#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Code Editors Package Installation
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Arch Editors]: Instalando editores de código via pacman/yay e flatpak..."

yay -S --needed --noconfirm mg micro helix neovim vim emacs geany

if command -v flatpak > "/dev/null" 2>&1; then
	flatpak install --assumeyes flathub com.visualstudio.code 2> "/dev/null" || true
fi

echo "✅ [Arch Editors]: Editores instalados com sucesso!"
