#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wifibox Driver Guest
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando subsistema Wifibox..."

${ELEVATE} pkg install --yes net/wifibox net/wifibox-alpine
${ELEVATE} sysrc wifibox_enable="YES"

_ui_ok "Wifibox instalado e habilitado no rc.conf!"
