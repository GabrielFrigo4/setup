#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Podman Container Engine
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Podman]: Instalando Podman nativo..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pkg install --yes sysutils/podman

echo "✅ [FreeBSD Podman]: Engine Podman nativa instalada com sucesso!"
