#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal Container Engines (Podman & Docker)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Podman e Docker..."

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

_ui_ok "Engines de container configuradas com sucesso!"
