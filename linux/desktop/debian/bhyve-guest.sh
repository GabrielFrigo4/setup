#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Debian Bhyve Guest Bootstrap & NFS Mirroring
# ----------------------------------------------------------------
set -eu

echo "📦 [Debian Bhyve Guest]: Configurando ambiente guest para integração com FreeBSD..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

### --------------------------------
### 1. Pacotes Básicos do Guest
### --------------------------------
${ELEVATE} apt update
${ELEVATE} apt install -y nfs-common curl sudo doas git-crypt

### --------------------------------
### 2. Alinhamento POSIX 1001
### --------------------------------
if id -u gabriel > "/dev/null" 2>&1; then
	_current_uid="$(id -u gabriel)"
	if [ "${_current_uid}" -ne 1001 ]; then
		echo "   🔄 Realinhando UID/GID do usuário gabriel para 1001..."
		${ELEVATE} sed -i "s/^gabriel:x:${_current_uid}:[0-9]*:/gabriel:x:1001:1001:/" /etc/passwd
		${ELEVATE} sed -i "s/^gabriel:x:[0-9]*:/gabriel:x:1001:/" /etc/group
		${ELEVATE} chown -R 1001:1001 /home/gabriel 2> "/dev/null" || true
	fi
fi

### --------------------------------
### 3. Escalonamento sem Senha
### --------------------------------
echo "gabriel ALL=(ALL:ALL) NOPASSWD: ALL" | ${ELEVATE} tee /etc/sudoers.d/gabriel > "/dev/null"
${ELEVATE} chmod 0440 /etc/sudoers.d/gabriel

echo "permit nopass gabriel as root" | ${ELEVATE} tee /etc/doas.conf > "/dev/null"
${ELEVATE} chmod 0400 /etc/doas.conf

### --------------------------------
### 4. Ponto de Montagem e NFSv3
### --------------------------------
${ELEVATE} mkdir -p /home/gabrielf
${ELEVATE} chown 1001:1001 /home/gabrielf

_fstab_entry="192.168.8.1:/home/gabrielf /home/gabrielf nfs rw,soft,intr,nfsvers=3 0 0"
if ! grep -q "/home/gabrielf" /etc/fstab 2> "/dev/null"; then
	echo "${_fstab_entry}" | ${ELEVATE} tee -a /etc/fstab > "/dev/null"
fi

${ELEVATE} mount /home/gabrielf 2> "/dev/null" || true

### --------------------------------
### 5. Binário do Agente Antigravity
### --------------------------------
if [ -f "/home/gabrielf/.gemini/antigravity-cli/bin/agy" ]; then
	${ELEVATE} ln -sf "/home/gabrielf/.gemini/antigravity-cli/bin/agy" "/usr/local/bin/agy"
elif [ -f "/tmp/agy" ]; then
	${ELEVATE} mv "/tmp/agy" "/usr/local/bin/agy"
	${ELEVATE} chmod 0755 "/usr/local/bin/agy"
fi

echo "✅ [Debian Bhyve Guest]: Configuração concluída com sucesso!"
