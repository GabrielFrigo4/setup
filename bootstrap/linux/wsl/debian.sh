#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: WSL Debian System, User & Development Environment
# ------------------------------------------------------------------------------
set -eu

echo "📦 [WSL Debian]: Configurando usuário, systemd e ferramentas base..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

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
	fastfetch

cat << 'EOF' | ${ELEVATE} tee "/etc/doas.conf" > "/dev/null"
permit nopass :sudo
EOF
${ELEVATE} chmod 0440 "/etc/doas.conf"

echo "✅ [WSL Debian]: Ambiente Debian WSL2 configurado com sucesso!"
