#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Debian Mesa & Nvidia Proprietary Graphics Drivers
# ------------------------------------------------------------------------------
set -eu

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} apt update
${ELEVATE} apt install --yes \
	mesa-utils \
	mesa-common-dev \
	libgl1-mesa-dev \
	nvidia-driver \
	firmware-misc-nonfree
