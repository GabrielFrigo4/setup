#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Bhyve Virtualization Manager & Debian Host
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Bhyve]: Configurando hipervisor Bhyve e rede virtual..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

### --------------------------------
### 1. Pacotes e Firmware
### --------------------------------
${ELEVATE} pkg install --yes sysutils/vm-bhyve sysutils/bhyve-firmware net/tigervnc-viewer

### --------------------------------
### 2. Persistência de Serviços
### --------------------------------
${ELEVATE} sysrc vm_enable="YES"
${ELEVATE} sysrc vm_dir="zfs:zroot/vm"
${ELEVATE} sysrc gateway_enable="YES"
${ELEVATE} sysrc pf_enable="YES"
${ELEVATE} sysrc pf_rules="/etc/pf.conf"
${ELEVATE} sysrc rpcbind_enable="YES"
${ELEVATE} sysrc nfs_server_enable="YES"
${ELEVATE} sysrc mountd_enable="YES"

### --------------------------------
### 3. Sysctl de Ponte e Roteamento
### --------------------------------
if ! grep -q "net.link.bridge.pfil_member=0" /etc/sysctl.conf 2> "/dev/null"; then
	cat <<- "EOF" | ${ELEVATE} tee -a /etc/sysctl.conf > "/dev/null"
		net.link.bridge.pfil_member=0
		net.link.bridge.pfil_bridge=0
	EOF
fi
${ELEVATE} sysctl net.link.bridge.pfil_member=0 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl net.link.bridge.pfil_bridge=0 > "/dev/null" 2>&1 || true

### --------------------------------
### 4. Switch Virtual e Rede
### --------------------------------
${ELEVATE} vm switch create public 2> "/dev/null" || true
${ELEVATE} vm switch address public 192.168.8.1/24 2> "/dev/null" || true

### --------------------------------
### 5. Exportação NFSv3
### --------------------------------
if [ -d "/home/gabrielf" ] && ! grep -q "/home/gabrielf.*192.168.8.2" /etc/exports 2> "/dev/null"; then
	echo "/home/gabrielf -alldirs -mapall=gabrielf 192.168.8.2" | ${ELEVATE} tee -a /etc/exports > "/dev/null"
	${ELEVATE} service mountd reload 2> "/dev/null" || true
fi

### --------------------------------
### 6. Template Bhyve Debian
### --------------------------------
${ELEVATE} mkdir -p /zroot/vm/.templates
cat <<- "EOF" | ${ELEVATE} tee /zroot/vm/.templates/debian.conf > "/dev/null"
	loader="uefi"
	cpu=4
	memory=2G
	network0_type="virtio-net"
	network0_switch="public"
	disk0_type="virtio-blk"
	disk0_name="disk0.img"
	utctime="yes"
EOF

echo "✅ [FreeBSD Bhyve]: Hipervisor e ambiente de virtualização configurados com sucesso!"
