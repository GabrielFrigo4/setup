#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wi-Fi Setup (wpa_supplicant)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wi-Fi]: Configurando serviço de rede sem fio..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

IFACE="${1:-wlan0}"

${ELEVATE} sysrc wpa_supplicant_enable="YES"
${ELEVATE} sysrc "ifconfig_${IFACE}"="WPA DHCP"

echo "✅ [FreeBSD Wi-Fi]: wpa_supplicant configurado para '${IFACE}'!"
