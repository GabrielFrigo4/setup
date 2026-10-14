#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wine & Windows Binary Emulation
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Wine e Winetricks..."

${ELEVATE} pkg install --yes emulators/wine emulators/winetricks

_ui_ok "Wine instalado com sucesso!"
