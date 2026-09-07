#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Debian Mesa & Nvidia Proprietary Graphics Drivers
# ------------------------------------------------------------------------------
set -eu

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} apt update
${ELEVATE} apt install --yes \
	mesa-utils \
	mesa-common-dev \
	libgl1-mesa-dev \
	nvidia-driver \
	firmware-misc-nonfree
