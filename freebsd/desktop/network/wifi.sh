#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wi-Fi Setup (wpa_supplicant)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando serviço de rede sem fio..."

IFACE="${1:-wlan0}"
PARENT_DEV="${2:-$(sysctl -n net.wlan.devices 2> "/dev/null" | awk '{print $1}' || true)}"

if command -v fwget > "/dev/null" 2>&1; then
	${ELEVATE} fwget pci > "/dev/null" 2>&1 || true
fi

if [ -n "${PARENT_DEV}" ]; then
	${ELEVATE} sysrc "wlans_${PARENT_DEV}"="${IFACE}" > "/dev/null" 2>&1 || true
fi
${ELEVATE} sysrc "create_args_${IFACE}"="country BR regdomain FCC" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc wpa_supplicant_enable="YES"
${ELEVATE} sysrc "ifconfig_${IFACE}"="WPA DHCP -bgscan"

_ui_ok "wpa_supplicant configurado para '${IFACE}'!"
