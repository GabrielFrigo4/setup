#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal 2GB Swap & Swappiness Setup
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando swap de 2GB e swappiness=10..."

if [ ! -f "/swap" ]; then
	${ELEVATE} fallocate -l 2G "/swap"
	${ELEVATE} chmod 0600 "/swap"
	${ELEVATE} mkswap "/swap"
	${ELEVATE} swapon "/swap"
	echo "/swap none swap sw 0 0" | ${ELEVATE} tee -a "/etc/fstab" > "/dev/null"
fi

${ELEVATE} sysctl vm.swappiness=10 > "/dev/null" 2>&1 || true
if ! grep -q "vm.swappiness=10" "/etc/sysctl.conf" 2> "/dev/null"; then
	echo "vm.swappiness=10" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
fi

_ui_ok "Swap configurado com sucesso!"
