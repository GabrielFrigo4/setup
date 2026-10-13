#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wi-Fi Setup (wpa_supplicant)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wi-Fi]: Configurando serviço de rede sem fio..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

IFACE="${1:-wlan0}"

${ELEVATE} sysrc wpa_supplicant_enable="YES"
${ELEVATE} sysrc "ifconfig_${IFACE}"="WPA DHCP"

echo "✅ [FreeBSD Wi-Fi]: wpa_supplicant configurado para '${IFACE}'!"
