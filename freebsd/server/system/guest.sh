#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Server Guest Integration (QEMU / KVM)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Guest]: Configurando agente QEMU e console..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pw groupmod wheel -m "$(id -un)"

${ELEVATE} pkg bootstrap --yes
${ELEVATE} pkg update
${ELEVATE} pkg upgrade --yes

${ELEVATE} pkg install --yes emulators/qemu-guest-agent
${ELEVATE} sysrc qemu_guest_agent_enable="YES"
${ELEVATE} sysrc qemu_guest_agent_flags="-d -m virtio-serial -p /dev/ttyV0.1"
${ELEVATE} service qemu-guest-agent start 2> "/dev/null" || true

${ELEVATE} sysrc allscreens_flags="-f spleen-16x32"

echo "✅ [FreeBSD Guest]: Agente QEMU ativo e console spleen configurado!"
