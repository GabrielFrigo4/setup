#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: KDE Plasma Wayland Desktop
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD KDE]: Configurando ambiente gráfico KDE Plasma..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes desktop-installer wl-clipboard xclip octopkg

echo "✅ [FreeBSD KDE]: Ambiente pronto! Execute 'desktop-installer' para seleção interativa se necessário."
