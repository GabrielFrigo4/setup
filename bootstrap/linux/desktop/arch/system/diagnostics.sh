#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Kernel & Firmware Diagnostics
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Arch Diagnostics]: Verificando kernel, firmwares e dispositivos..."

sudo pacman -S --needed --noconfirm linux linux-firmware
cat /proc/bus/input/devices

echo "✅ [Arch Diagnostics]: Diagnóstico concluído!"
