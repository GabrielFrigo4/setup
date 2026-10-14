#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Debian Mesa & Nvidia Proprietary Graphics Drivers
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando drivers de vídeo Mesa e Nvidia..."

${ELEVATE} apt update
${ELEVATE} apt install --yes \
	mesa-utils \
	mesa-common-dev \
	libgl1-mesa-dev \
	nvidia-driver \
	firmware-misc-nonfree

_ui_ok "Drivers de vídeo configurados com sucesso!"
