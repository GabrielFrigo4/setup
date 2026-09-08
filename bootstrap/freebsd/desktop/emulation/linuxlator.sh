#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linuxlator Compatibility Layer
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Linuxlator]: Ativando camada de compatibilidade Linux..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} sysrc linux_enable="YES"
${ELEVATE} service linux start 2> "/dev/null" || true

echo "✅ [FreeBSD Linuxlator]: Compatibilidade Linux ativa no kernel!"
