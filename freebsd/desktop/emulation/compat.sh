#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Compat Layer (/compat/linux)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Compat]: Ativando camada de compatibilidade Linux (/compat/linux)..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} sysrc linux_enable="YES"
${ELEVATE} service linux start 2> "/dev/null" || true

echo "✅ [FreeBSD Compat]: Camada de compatibilidade (/compat/linux) ativa no kernel!"
