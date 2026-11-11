#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Podman Container Engine
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Podman nativo no FreeBSD..."

${ELEVATE} pkg install -y sysutils/podman
${ELEVATE} sysctl net.pf.filter_local=1 > "/dev/null" 2>&1 || true
grep -qxF "net.pf.filter_local=1" "/etc/sysctl.conf" 2> "/dev/null" || echo "net.pf.filter_local=1" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
${ELEVATE} sysrc linux_enable="YES" > "/dev/null" 2>&1 || true

_ui_ok "Engine Podman nativa instalada com sucesso!"
