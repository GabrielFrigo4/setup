#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Webcam Service Setup (webcamd)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Webcam]: Configurando serviço de webcam..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes webcamd
${ELEVATE} sysrc webcamd_enable="YES"
${ELEVATE} service webcamd start 2> "/dev/null" || true

echo "✅ [FreeBSD Webcam]: Serviço webcamd configurado e ativo!"
