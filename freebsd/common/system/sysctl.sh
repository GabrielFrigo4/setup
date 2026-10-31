#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Universal System & Kernel Tweaks
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Aplicando otimizações de kernel FreeBSD..."

_set_sysctl() {
	_key="$1"
	_val="$2"
	${ELEVATE} sysctl "${_key}=${_val}" > "/dev/null" 2>&1 || true
	if grep -q "^[[:space:]]*${_key}=" "/etc/sysctl.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' "s|^[[:space:]]*${_key}=.*|${_key}=${_val}|" "/etc/sysctl.conf"
	else
		echo "${_key}=${_val}" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
	fi
}

${ELEVATE} sed -i '' '/# Default USB Audio/d' "/etc/sysctl.conf" 2> "/dev/null" || true

### --------------------------------
### Core Dump e Seguranca
### --------------------------------
_set_sysctl "kern.coredump" "0"

### --------------------------------
### Descritores de Arquivos
### --------------------------------
_set_sysctl "kern.maxfiles" "1048576"
_set_sysctl "kern.maxfilesperproc" "524288"

### --------------------------------
### Memoria Compartilhada IPC SHM
### --------------------------------
_set_sysctl "kern.ipc.shmmax" "2147483648"
_set_sysctl "kern.ipc.shmall" "524288"
_set_sysctl "kern.ipc.shm_allow_removed" "1"

### --------------------------------
### Roteamento e Mixer de Audio
### --------------------------------
_set_sysctl "hw.snd.default_unit" "2"
_set_sysctl "dev.pcm.2.mixer.vol_0_0.val" "0"
_set_sysctl "dev.pcm.2.mixer.vol_0_1.val" "0"

_ui_ok "Otimizações aplicadas com sucesso!"
