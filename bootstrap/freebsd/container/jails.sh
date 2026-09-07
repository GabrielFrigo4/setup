#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: FreeBSD Native Jails Subsystem
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Jails]: Ativando subsistema nativo de Jails..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} sysrc jail_enable="YES"
${ELEVATE} mkdir -p "/usr/jails"

echo "✅ [FreeBSD Jails]: Subsistema de Jails ativo no rc.conf!"
