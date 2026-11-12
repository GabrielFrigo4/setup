#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Universal System & Kernel Tweaks
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Aplicando otimizações de kernel FreeBSD..."

${ELEVATE} rm -f /etc/rc.conf\'\' /etc/sysctl.conf\'\' /boot/loader.conf\'\' /etc/*.conf\'\' /boot/*.conf\'\' 2> "/dev/null" || true

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

if [ -f "/etc/sysctl.conf" ]; then
	_tmp="$(mktemp "/tmp/sysctl.conf.XXXXXX")"
	sed -e '/# Default USB Audio/d' -e '/^dev\.pcm\.2\.mixer\./d' "/etc/sysctl.conf" > "${_tmp}"
	${ELEVATE} cp "${_tmp}" "/etc/sysctl.conf"
	${ELEVATE} chmod 0644 "/etc/sysctl.conf"
	rm -f "${_tmp}"
fi

### --------------------------------
### CORE DUMP E SEGURANCA
### --------------------------------
_set_sysctl "kern.coredump" "0"

### --------------------------------
### DESCRITORES DE ARQUIVOS
### --------------------------------
_set_sysctl "kern.maxfiles" "1048576"
_set_sysctl "kern.maxfilesperproc" "524288"

### --------------------------------
### MEMORIA COMPARTILHADA IPC SHM
### --------------------------------
_set_sysctl "kern.ipc.shmmax" "2147483648"
_set_sysctl "kern.ipc.shmall" "524288"
_set_sysctl "kern.ipc.shm_allow_removed" "1"

### --------------------------------
### ROTEAMENTO E MIXER DE AUDIO
### --------------------------------
_set_sysctl "hw.snd.default_unit" "1"

if sysctl dev.pcm.2 > "/dev/null" 2>&1; then
	${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 > "/dev/null" 2>&1 || true
	${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true
fi

${ELEVATE} rm -f /etc/rc.conf\'\' /etc/sysctl.conf\'\' /boot/loader.conf\'\' /etc/*.conf\'\' /boot/*.conf\'\' 2> "/dev/null" || true

_ui_ok "Otimizações aplicadas com sucesso!"
