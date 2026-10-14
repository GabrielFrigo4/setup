#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: WSL Debian System, User & Development Environment
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando usuário, systemd e ferramentas base Debian WSL2..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-gabriel}}"

if ! id "${TARGET_USER}" > "/dev/null" 2>&1; then
	useradd -m -G sudo -s /usr/bin/bash "${TARGET_USER}"
fi

cat << 'EOF' | ${ELEVATE} tee "/etc/sudoers.d/sudo" > "/dev/null"
%sudo ALL=(ALL:ALL) NOPASSWD: ALL
EOF
${ELEVATE} chmod 0440 "/etc/sudoers.d/sudo"

cat << EOF | ${ELEVATE} tee "/etc/wsl.conf" > "/dev/null"
[boot]
systemd=true

[user]
default=${TARGET_USER}
EOF

${ELEVATE} apt update
${ELEVATE} apt upgrade --yes
${ELEVATE} apt install --yes \
	doas \
	build-essential \
	git \
	curl \
	wget \
	mandoc \
	eza \
	bat \
	ripgrep \
	fd-find \
	zoxide \
	fastfetch

cat << 'EOF' | ${ELEVATE} tee "/etc/doas.conf" > "/dev/null"
permit nopass :sudo
EOF
${ELEVATE} chmod 0440 "/etc/doas.conf"

_ui_ok "Ambiente Debian WSL2 configurado com sucesso!"
