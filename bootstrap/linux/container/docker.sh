#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Docker CE Official Repositories & Engine
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Linux Docker]: Instalando Docker CE oficial..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo" 2> "/dev/null" || true
	${ELEVATE} dnf install --assumeyes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes docker.io docker-compose 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm docker docker-compose 2> "/dev/null" || true
fi

${ELEVATE} systemctl enable --now docker 2> "/dev/null" || true
${ELEVATE} usermod --append --groups docker "${TARGET_USER}" 2> "/dev/null" || true

echo "✅ [Linux Docker]: Docker CE configurado e usuário '${TARGET_USER}' adicionado ao grupo docker!"
