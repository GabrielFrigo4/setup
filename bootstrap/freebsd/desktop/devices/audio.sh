#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Audio Routing to Android (RTP)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Audio]: Iniciando roteamento de áudio..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

if ! ifconfig ue0 > "/dev/null" 2>&1; then
	echo "❌ [FreeBSD Audio]: Interface 'ue0' não encontrada! Conecte o USB com tethering ativo."
	exit 1
fi

${ELEVATE} dhclient ue0 > "/dev/null" 2>&1 || true

PHONE_IP="$(grep 'dhcp-server-identifier' "/var/db/dhclient.leases.ue0" 2> "/dev/null" | tail -1 | awk '{print $3}' | tr -d ';')"

if [ -z "${PHONE_IP}" ]; then
	echo "❌ [FreeBSD Audio]: Não foi possível determinar o IP do celular."
	exit 1
fi

echo "   📱 Celular detectado em: ${PHONE_IP}"
pactl unload-module module-rtp-send > "/dev/null" 2>&1 || true
pactl load-module module-rtp-send source=oss_output.dsp0.monitor destination_ip="${PHONE_IP}" port=5004 > "/dev/null"

echo "✅ [FreeBSD Audio]: Roteado! Abra o VLC no Android em 'rtp://@:5004'."
