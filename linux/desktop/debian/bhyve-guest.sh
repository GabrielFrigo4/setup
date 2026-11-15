#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Debian Bhyve Guest Bootstrap & NFS Mirroring
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_guest_user="${GUEST_USER:-${SUDO_USER:-${DOAS_USER:-$(awk -F: '$3 >= 1000 && $3 < 65000 { print $1; exit }' /etc/passwd 2> "/dev/null" || id -un)}}}"
_guest_home="$(awk -F: -v u="${_guest_user}" '$1 == u { print $6; exit }' /etc/passwd 2> "/dev/null" || echo "/home/${_guest_user}")"
_host_user="${HOST_USER:-${_guest_user}}"
_host_home="${HOST_HOME:-/home/${_host_user}}"
_nfs_server="${NFS_HOST_IP:-192.168.8.1}"

_ui_step "Configurando ambiente guest para integração com FreeBSD..."

### --------------------------------
### 1. PACOTES BASICOS DO GUEST
### --------------------------------
${ELEVATE} apt update
${ELEVATE} apt install --yes nfs-common curl sudo doas git-crypt

### --------------------------------
### 2. ALINHAMENTO POSIX 1001
### --------------------------------
if [ -n "${_guest_user}" ] && [ "${_guest_user}" != "root" ] && id -u "${_guest_user}" > "/dev/null" 2>&1; then
	_current_uid="$(id -u "${_guest_user}")"
	if [ "${_current_uid}" -ne 1001 ]; then
		_ui_sub "Realinhando UID/GID do usuário ${_guest_user} para 1001..."
		${ELEVATE} sed -i "s/^${_guest_user}:x:${_current_uid}:[0-9]*:/${_guest_user}:x:1001:1001:/" /etc/passwd
		${ELEVATE} sed -i "s/^${_guest_user}:x:[0-9]*:/${_guest_user}:x:1001:/" /etc/group
		${ELEVATE} chown -R 1001:1001 "${_guest_home}" 2> "/dev/null" || true
	fi
fi

### --------------------------------
### 3. ESCALONAMENTO SEM SENHA
### --------------------------------
if [ -n "${_guest_user}" ] && [ "${_guest_user}" != "root" ]; then
	echo "${_guest_user} ALL=(ALL:ALL) NOPASSWD: ALL" | ${ELEVATE} tee "/etc/sudoers.d/${_guest_user}" > "/dev/null"
	${ELEVATE} chmod 0440 "/etc/sudoers.d/${_guest_user}"

	echo "permit nopass ${_guest_user} as root" | ${ELEVATE} tee /etc/doas.conf > "/dev/null"
	${ELEVATE} chmod 0400 /etc/doas.conf
fi

### --------------------------------
### 4. PONTO DE MONTAGEM E NFSV3
### --------------------------------
${ELEVATE} mkdir -p "${_host_home}"
${ELEVATE} chown 1001:1001 "${_host_home}"

_fstab_entry="${_nfs_server}:${_host_home} ${_host_home} nfs rw,soft,intr,nfsvers=3 0 0"
if ! grep -q "${_host_home}" /etc/fstab 2> "/dev/null"; then
	echo "${_fstab_entry}" | ${ELEVATE} tee -a /etc/fstab > "/dev/null"
fi

${ELEVATE} mount "${_host_home}" 2> "/dev/null" || true

### --------------------------------
### 5. BINARIO DO AGENTE ANTIGRAVITY
### --------------------------------
if [ -f "${_host_home}/.gemini/antigravity-cli/bin/agy" ]; then
	${ELEVATE} ln -sf "${_host_home}/.gemini/antigravity-cli/bin/agy" "/usr/local/bin/agy"
elif [ -f "/tmp/agy" ]; then
	${ELEVATE} mv "/tmp/agy" "/usr/local/bin/agy"
	${ELEVATE} chmod 0755 "/usr/local/bin/agy"
fi

_ui_ok "Configuração concluída com sucesso!"
