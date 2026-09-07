#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: FreeBSD Server Guest Integration (QEMU / KVM)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Guest]: Configurando agente QEMU e console..."

pw groupmod wheel -m "$(id -un)"

pkg bootstrap --yes
pkg update
pkg upgrade --yes

pkg install --yes qemu-guest-agent
sysrc qemu_guest_agent_enable="YES"
sysrc qemu_guest_agent_flags="-d -m virtio-serial -p /dev/ttyV0.1"
service qemu-guest-agent start 2> "/dev/null" || true

sysrc allscreens_flags="-f spleen-16x32"

echo "✅ [FreeBSD Guest]: Agente QEMU ativo e console spleen configurado!"
