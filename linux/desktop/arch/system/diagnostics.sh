#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Kernel & Firmware Diagnostics
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Verificando kernel, firmwares e dispositivos..."

${ELEVATE} pacman -S --needed --noconfirm linux linux-firmware
cat /proc/bus/input/devices

_ui_ok "Diagnóstico concluído!"
