#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Server Guest Integration (QEMU / KVM)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "FreeBSD Guest: Configurando agente QEMU e console..."

${ELEVATE} pw groupmod wheel -m "$(id -un)"

${ELEVATE} pkg bootstrap --yes
${ELEVATE} pkg update
${ELEVATE} pkg upgrade --yes

${ELEVATE} pkg install --yes emulators/qemu-guest-agent
${ELEVATE} sysrc qemu_guest_agent_enable="YES"
${ELEVATE} sysrc qemu_guest_agent_flags="-d -m virtio-serial -p /dev/ttyV0.1"
${ELEVATE} service qemu-guest-agent start 2> "/dev/null" || true

${ELEVATE} sysrc allscreens_flags="-f spleen-16x32"

_ui_ok "FreeBSD Guest: Agente QEMU ativo e console spleen configurado!"
