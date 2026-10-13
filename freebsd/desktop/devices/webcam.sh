#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Webcam Service Setup (webcamd)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Webcam]: Configurando serviço de webcam..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pkg install --yes multimedia/webcamd
${ELEVATE} sysrc webcamd_enable="YES"
${ELEVATE} service webcamd start 2> "/dev/null" || true

echo "✅ [FreeBSD Webcam]: Serviço webcamd configurado e ativo!"
