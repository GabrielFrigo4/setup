#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Debian Base System & Repositories
# ------------------------------------------------------------------------------
set -eu

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
${ELEVATE} usermod --append --groups sudo "${TARGET_USER}" 2> "/dev/null" || true

if [ -f "/etc/apt/sources.list" ]; then
	${ELEVATE} sed -i 's/main non-free-firmware/main non-free-firmware contrib non-free/' "/etc/apt/sources.list" 2> "/dev/null" || true
fi

${ELEVATE} apt update
${ELEVATE} apt install --yes gnupg ca-certificates apt-transport-https
