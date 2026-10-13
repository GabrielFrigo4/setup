#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Kernel & Firmware Diagnostics
# ----------------------------------------------------------------
set -eu

echo "📦 [Arch Diagnostics]: Verificando kernel, firmwares e dispositivos..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pacman -S --needed --noconfirm linux linux-firmware
cat /proc/bus/input/devices

echo "✅ [Arch Diagnostics]: Diagnóstico concluído!"
