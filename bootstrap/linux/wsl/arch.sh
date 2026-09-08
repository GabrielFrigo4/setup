#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: WSL Arch Linux System, User & Development Environment
# ------------------------------------------------------------------------------
set -eu

echo "📦 [WSL Arch Linux]: Configurando usuário, systemd e ferramentas base..."

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

${ELEVATE} pacman-key --init 2> "/dev/null" || true
${ELEVATE} pacman-key --populate archlinux 2> "/dev/null" || true

${ELEVATE} pacman -Syu --needed --noconfirm \
	archlinux-keyring \
	opendoas \
	base-devel \
	git \
	curl \
	wget \
	mandoc \
	eza \
	bat \
	ripgrep \
	fd \
	fastfetch

cat << 'EOF' | ${ELEVATE} tee "/etc/doas.conf" > "/dev/null"
permit nopass :wheel
EOF
${ELEVATE} chmod 0440 "/etc/doas.conf"

echo "✅ [WSL Arch Linux]: Ambiente Arch WSL2 configurado com sucesso!"
