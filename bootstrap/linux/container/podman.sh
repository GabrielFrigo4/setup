#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Linux Universal Container Engines (Podman & Docker)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Linux Containers]: Instalando Podman e Docker..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes podman
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes podman docker.io
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm podman docker
fi

${ELEVATE} systemctl enable --now docker 2> "/dev/null" || true
${ELEVATE} usermod --append --groups docker "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} loginctl enable-linger "${TARGET_USER}" 2> "/dev/null" || true

echo "✅ [Linux Containers]: Engines de container configuradas com sucesso!"
