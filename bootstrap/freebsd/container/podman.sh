#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: FreeBSD Native Podman Container Engine
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Podman]: Instalando Podman nativo..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes podman

echo "✅ [FreeBSD Podman]: Engine Podman nativa instalada com sucesso!"
