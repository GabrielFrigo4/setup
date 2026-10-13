#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Debian Mesa & Nvidia Proprietary Graphics Drivers
# ----------------------------------------------------------------
set -eu

echo "📦 [Debian Drivers]: Instalando drivers de vídeo Mesa e Nvidia..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} apt update
${ELEVATE} apt install --yes \
	mesa-utils \
	mesa-common-dev \
	libgl1-mesa-dev \
	nvidia-driver \
	firmware-misc-nonfree

echo "✅ [Debian Drivers]: Drivers de vídeo configurados com sucesso!"
