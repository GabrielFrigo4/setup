#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: FreeBSD Universal System & Kernel Tweaks
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD System]: Aplicando otimizações de kernel..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} sysctl kern.coredump=0 > "/dev/null" 2>&1 || true
if ! grep -q "kern.coredump=0" "/etc/sysctl.conf" 2> "/dev/null"; then
	echo "kern.coredump=0" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
fi

echo "✅ [FreeBSD System]: Otimizações aplicadas com sucesso!"
