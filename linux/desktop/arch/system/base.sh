#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Base System, SDDM & Journald
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando sistema base, SDDM e journald Arch Linux..."

${ELEVATE} pacman-mirrors --fasttrack 5 2> "/dev/null" || true
${ELEVATE} pacman -Syyu --needed --noconfirm zsh

if command -v zsh > "/dev/null" 2>&1; then
	TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	ZSH_BIN="$(command -v zsh)"
	if [ "$(getent passwd "${TARGET_USER}" 2> "/dev/null" | cut -d: -f7)" != "${ZSH_BIN}" ]; then
		${ELEVATE} chsh -s "${ZSH_BIN}" "${TARGET_USER}" 2> "/dev/null" || true
	fi
fi

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

_ui_ok "Sistema base configurado com sucesso!"
