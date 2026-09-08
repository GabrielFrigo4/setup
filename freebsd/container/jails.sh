#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Jails Subsystem
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Jails]: Ativando subsistema nativo de Jails..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} sysrc jail_enable="YES"
${ELEVATE} mkdir -p "/usr/jails"

echo "✅ [FreeBSD Jails]: Subsistema de Jails ativo no rc.conf!"
