#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: KDE Plasma Wayland Desktop
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD KDE]: Configurando ambiente gráfico KDE Plasma..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes sysutils/desktop-installer x11/wl-clipboard x11/xclip ports-mgmt/octopkg archivers/ark x11-themes/plasma6-breeze-gtk

echo "✅ [FreeBSD KDE]: Ambiente pronto! Execute 'desktop-installer' para seleção interativa se necessário."
