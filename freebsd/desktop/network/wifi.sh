#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wi-Fi Setup (wpa_supplicant)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando serviço de rede sem fio..."

IFACE="${1:-wlan0}"

${ELEVATE} sysrc wpa_supplicant_enable="YES"
${ELEVATE} sysrc "ifconfig_${IFACE}"="WPA DHCP"

_ui_ok "wpa_supplicant configurado para '${IFACE}'!"
