#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Base System Setup
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD System]: Iniciando configuração base..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

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

${ELEVATE} sysctl hw.snd.default_unit=2 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true

if ! grep -q "hw.snd.default_unit=2" "/etc/sysctl.conf" 2> "/dev/null"; then
	cat <<- "EOF" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
	# Default USB Audio
	hw.snd.default_unit=2
	dev.pcm.2.mixer.vol_0_0.val=0
	dev.pcm.2.mixer.vol_0_1.val=0
	EOF
fi

mkdir -p "${HOME}/Workspace"

echo "✅ [FreeBSD System]: Configuração base concluída com sucesso!"
