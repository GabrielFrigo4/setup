#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Podman Container Engine
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Podman]: Instalando Podman nativo..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes podman

echo "✅ [FreeBSD Podman]: Engine Podman nativa instalada com sucesso!"
