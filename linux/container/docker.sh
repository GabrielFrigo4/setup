#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Docker CE Official Repositories & Engine
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Docker CE oficial..."

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

_ui_ok "Docker CE configurado e usuário '${TARGET_USER}' adicionado ao grupo docker!"
