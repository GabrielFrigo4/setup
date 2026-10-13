#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Compat Layer (/compat/linux)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Compat]: Ativando camada de compatibilidade Linux (/compat/linux)..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} sysrc linux_enable="YES"
${ELEVATE} service linux start 2> "/dev/null" || true

echo "✅ [FreeBSD Compat]: Camada de compatibilidade (/compat/linux) ativa no kernel!"
