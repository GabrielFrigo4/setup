#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: WSL Fedora / Rocky Linux System & Development Environment (DNF)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [WSL Fedora]: Configurando usuário, systemd e ferramentas base..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

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
	fastfetch

cat << 'EOF' | ${ELEVATE} tee "/etc/doas.conf" > "/dev/null"
permit nopass :wheel
EOF
${ELEVATE} chmod 0440 "/etc/doas.conf"

echo "✅ [WSL Fedora]: Ambiente Fedora WSL2 (DNF) configurado com sucesso!"
