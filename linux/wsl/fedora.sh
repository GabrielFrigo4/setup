#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: WSL Fedora Development Environment (DNF)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando usuário, systemd e ferramentas base Fedora WSL2..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-gabriel}}"

if ! id "${TARGET_USER}" > "/dev/null" 2>&1; then
	useradd -m -G wheel -s /usr/bin/bash "${TARGET_USER}"
fi

cat << 'EOF' | ${ELEVATE} tee "/etc/sudoers.d/wheel" > "/dev/null"
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF
${ELEVATE} chmod 0440 "/etc/sudoers.d/wheel"

cat << EOF | ${ELEVATE} tee "/etc/wsl.conf" > "/dev/null"
[boot]
systemd=true

[user]
default=${TARGET_USER}
EOF

${ELEVATE} dnf upgrade --assumeyes
${ELEVATE} dnf install --assumeyes \
	opendoas \
	@development-tools \
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
permit nopass :wheel
EOF
${ELEVATE} chmod 0440 "/etc/doas.conf"

_ui_ok "Ambiente Fedora WSL2 configurado com sucesso!"
