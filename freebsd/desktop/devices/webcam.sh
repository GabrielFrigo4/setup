#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Webcam Service Setup (webcamd)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando serviço de webcam..."

${ELEVATE} pkg install --yes multimedia/webcamd
${ELEVATE} sysrc webcamd_enable="YES"
${ELEVATE} service webcamd start 2> "/dev/null" || true

_ui_ok "Serviço webcamd configurado e ativo!"
