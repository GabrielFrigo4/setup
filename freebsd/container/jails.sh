#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Jails Subsystem
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Jails]: Ativando subsistema nativo de Jails..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} sysrc jail_enable="YES"
${ELEVATE} mkdir -p "/usr/jails"

echo "✅ [FreeBSD Jails]: Subsistema de Jails ativo no rc.conf!"
