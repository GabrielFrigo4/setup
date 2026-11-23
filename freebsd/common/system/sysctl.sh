#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Portable Kernel & IPC Sysctl Optimizations
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Aplicando otimizações portáteis de kernel FreeBSD..."

_set_sysctl() {
	_key="$1"
	_val="$2"
	${ELEVATE} sysctl "${_key}=${_val}" > "/dev/null" 2>&1 || true
	if grep -q "^[[:space:]]*${_key}=" "/etc/sysctl.conf" 2> "/dev/null"; then
		_tmp="$(mktemp "/tmp/sysctl.conf.XXXXXX")"
		sed "s|^[[:space:]]*${_key}=.*|${_key}=${_val}|" "/etc/sysctl.conf" > "${_tmp}"
		${ELEVATE} cp "${_tmp}" "/etc/sysctl.conf"
		${ELEVATE} chmod 0644 "/etc/sysctl.conf"
		rm -f "${_tmp}"
	else
		echo "${_key}=${_val}" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
	fi
}

### --------------------------------
### CORE DUMP AND FILES
### --------------------------------
_set_sysctl "kern.coredump" "0"
_set_sysctl "kern.maxfiles" "1048576"
_set_sysctl "kern.maxfilesperproc" "524288"

### --------------------------------
### SHARED MEMORY IPC SHM
### --------------------------------
_set_sysctl "kern.ipc.shmmax" "2147483648"
_set_sysctl "kern.ipc.shmall" "524288"
_set_sysctl "kern.ipc.shm_allow_removed" "1"

### --------------------------------
### LINUX COMPAT AND VM
### --------------------------------
_set_sysctl "compat.linux.debug" "0"
_set_sysctl "vm.pageout_oom_seq" "120"
_set_sysctl "vfs.usermount" "1"

_ui_ok "Otimizações de kernel aplicadas com sucesso!"
