#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Base System, SDDM & Journald
# ------------------------------------------------------------------------------
set -eu

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pacman-mirrors --fasttrack 5 2> "/dev/null" || true
${ELEVATE} pacman -Syyu --needed --noconfirm

if [ -f "/etc/sddm.conf" ]; then
	${ELEVATE} sed -i 's/Numlock=none/Numlock=on/' "/etc/sddm.conf" 2> "/dev/null" || true
	${ELEVATE} sed -i 's/EnableHiDPI=false/EnableHiDPI=true/' "/etc/sddm.conf" 2> "/dev/null" || true
fi

${ELEVATE} mkdir -p "/etc/systemd/journald.conf.d/"
cat << 'EOF' | ${ELEVATE} tee "/etc/systemd/journald.conf.d/00-size-limit.conf" > "/dev/null"
[Journal]
SystemMaxUse=256M
EOF
${ELEVATE} systemctl restart systemd-journald 2> "/dev/null" || true
