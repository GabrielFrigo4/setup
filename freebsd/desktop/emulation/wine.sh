#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wine & Windows Binary Emulation
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wine]: Instalando Wine e Winetricks..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pkg install --yes emulators/wine emulators/winetricks

echo "✅ [FreeBSD Wine]: Wine instalado com sucesso!"
