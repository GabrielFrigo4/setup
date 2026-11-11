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
PARENT_DEV="rtw880"

if command -v fwget > "/dev/null" 2>&1; then
	${ELEVATE} fwget pci > "/dev/null" 2>&1 || true
elif command -v pkg > "/dev/null" 2>&1; then
	if ! pkg info -x "^wifi-firmware-rtw88-kmod" > "/dev/null" 2>&1; then
		${ELEVATE} pkg install -y wifi-firmware-rtw88-kmod-rtw8821c 2> "/dev/null" || true
	fi
fi

${ELEVATE} sysrc "wlans_${PARENT_DEV}"="${IFACE}" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc "create_args_${IFACE}"="country BR regdomain FCC" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc wpa_supplicant_enable="YES"
${ELEVATE} sysrc "ifconfig_${IFACE}"="WPA DHCP"

_ui_ok "wpa_supplicant configurado para '${IFACE}'!"
