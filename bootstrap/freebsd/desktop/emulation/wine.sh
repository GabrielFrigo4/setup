#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Wine & Windows Binary Emulation
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wine]: Instalando Wine e Winetricks..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes wine winetricks

echo "✅ [FreeBSD Wine]: Wine instalado com sucesso!"
