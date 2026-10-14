#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Microphone Routing from Android (RTP)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando entrada de microfone via Android..."

pactl unload-module module-rtp-recv > "/dev/null" 2>&1 || true
pactl unload-module module-null-sink > "/dev/null" 2>&1 || true

pactl load-module module-null-sink sink_name=android_mic sink_properties=device.description="Android_Microphone" > "/dev/null"
pactl load-module module-rtp-recv sink=android_mic port=5005 > "/dev/null"

_ui_ok "Pronto! Transmita o áudio do celular para a porta 5005 via RTP."
