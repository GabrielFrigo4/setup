#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Wifibox Driver Guest
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wifibox]: Instalando subsistema Wifibox..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes wifibox wifibox-alpine
${ELEVATE} sysrc wifibox_enable="YES"

echo "✅ [FreeBSD Wifibox]: Wifibox instalado e habilitado no rc.conf!"
