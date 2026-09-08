#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Kernel & Firmware Diagnostics
# ----------------------------------------------------------------
set -eu

echo "📦 [Arch Diagnostics]: Verificando kernel, firmwares e dispositivos..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pacman -S --needed --noconfirm linux linux-firmware
cat /proc/bus/input/devices

echo "✅ [Arch Diagnostics]: Diagnóstico concluído!"
