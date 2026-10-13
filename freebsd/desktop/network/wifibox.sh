#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wifibox Driver Guest
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wifibox]: Instalando subsistema Wifibox..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pkg install --yes net/wifibox net/wifibox-alpine
${ELEVATE} sysrc wifibox_enable="YES"

echo "✅ [FreeBSD Wifibox]: Wifibox instalado e habilitado no rc.conf!"
