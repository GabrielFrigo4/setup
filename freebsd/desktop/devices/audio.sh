#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Audio Routing to Android (RTP)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Iniciando roteamento de áudio..."

if ! ifconfig ue0 > "/dev/null" 2>&1; then
	_ui_err "Interface 'ue0' não encontrada! Conecte o USB com tethering ativo."
	exit 1
fi

${ELEVATE} dhclient ue0 > "/dev/null" 2>&1 || true

PHONE_IP="$(grep 'dhcp-server-identifier' "/var/db/dhclient.leases.ue0" 2> "/dev/null" | tail -1 | awk '{print $3}' | tr -d ';')"

if [ -z "${PHONE_IP}" ]; then
	_ui_err "Não foi possível determinar o IP do celular."
	exit 1
fi

_ui_sub "Celular detectado em: ${PHONE_IP}"
pactl unload-module module-rtp-send > "/dev/null" 2>&1 || true
pactl load-module module-rtp-send source=oss_output.dsp0.monitor destination_ip="${PHONE_IP}" port=5004 > "/dev/null"

_ui_ok "Roteado! Abra o VLC no Android em 'rtp://@:5004'."
