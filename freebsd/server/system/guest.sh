#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Server Guest Integration (QEMU / KVM)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Guest]: Configurando agente QEMU e console..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pw groupmod wheel -m "$(id -un)"

${ELEVATE} pkg bootstrap --yes
${ELEVATE} pkg update
${ELEVATE} pkg upgrade --yes

${ELEVATE} pkg install --yes qemu-guest-agent
${ELEVATE} sysrc qemu_guest_agent_enable="YES"
${ELEVATE} sysrc qemu_guest_agent_flags="-d -m virtio-serial -p /dev/ttyV0.1"
${ELEVATE} service qemu-guest-agent start 2> "/dev/null" || true

${ELEVATE} sysrc allscreens_flags="-f spleen-16x32"

echo "✅ [FreeBSD Guest]: Agente QEMU ativo e console spleen configurado!"
