#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Wine & Windows Binary Emulation
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wine]: Instalando Wine e Winetricks..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes wine winetricks

echo "✅ [FreeBSD Wine]: Wine instalado com sucesso!"
