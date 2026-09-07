#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Base System Setup
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD System]: Iniciando configuração base..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} pw groupmod wheel -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod operator -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod video -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod webcamd -m "${TARGET_USER}" 2> "/dev/null" || true

${ELEVATE} pkg bootstrap --yes
${ELEVATE} pkg update

${ELEVATE} sysrc allscreens_flags="-f spleen-16x32"

${ELEVATE} sysctl kern.coredump=0 > "/dev/null" 2>&1 || true
grep -qxF "kern.coredump=0" "/etc/sysctl.conf" 2> "/dev/null" || echo "kern.coredump=0" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"

mkdir -p "${HOME}/Workspace"

echo "✅ [FreeBSD System]: Configuração base concluída com sucesso!"
