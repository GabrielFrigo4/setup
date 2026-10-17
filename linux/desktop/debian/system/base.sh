#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Debian Base System & Repositories
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando repositórios e sistema base Debian..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
${ELEVATE} usermod --append --groups sudo "${TARGET_USER}" 2> "/dev/null" || true

if [ -f "/etc/apt/sources.list" ]; then
	${ELEVATE} sed -i 's/main non-free-firmware/main non-free-firmware contrib non-free/' "/etc/apt/sources.list" 2> "/dev/null" || true
fi

${ELEVATE} apt update
${ELEVATE} apt install --yes gnupg ca-certificates apt-transport-https

_console_recipe="${_setup_root}/linux/common/system/console.sh"
if [ -f "${_console_recipe}" ]; then
	sh "${_console_recipe}"
fi

_ui_ok "Sistema base configurado com sucesso!"
