#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Debian Base System & Repositories
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Debian Base]: Configurando repositórios e sistema base..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
${ELEVATE} usermod --append --groups sudo "${TARGET_USER}" 2> "/dev/null" || true

if [ -f "/etc/apt/sources.list" ]; then
	${ELEVATE} sed -i 's/main non-free-firmware/main non-free-firmware contrib non-free/' "/etc/apt/sources.list" 2> "/dev/null" || true
fi

${ELEVATE} apt update
${ELEVATE} apt install --yes gnupg ca-certificates apt-transport-https

echo "✅ [Debian Base]: Sistema base configurado com sucesso!"
