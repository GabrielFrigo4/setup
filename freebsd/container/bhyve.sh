#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Bhyve Virtualization Manager & Debian Host
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando hipervisor Bhyve e rede virtual..."

### --------------------------------
### 1. PACOTES E FIRMWARE
### --------------------------------
${ELEVATE} pkg install -y sysutils/vm-bhyve sysutils/bhyve-firmware net/tigervnc-viewer

### --------------------------------
### 2. PERSISTENCIA DE SERVICOS
### --------------------------------
${ELEVATE} sysrc vm_enable="YES"
${ELEVATE} sysrc vm_dir="zfs:zroot/vm"
${ELEVATE} sysrc vm_list=""
${ELEVATE} sysrc gateway_enable="YES"
${ELEVATE} sysrc pf_enable="YES"
${ELEVATE} sysrc pf_rules="/etc/pf.conf"
${ELEVATE} sysrc rpcbind_enable="YES"
${ELEVATE} sysrc nfs_server_enable="YES"
${ELEVATE} sysrc mountd_enable="YES"

### --------------------------------
### 3. SYSCTL E ROTEAMENTO
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
### 4. SWITCH VIRTUAL E REDE
### --------------------------------
${ELEVATE} zfs create -o mountpoint=/zroot/vm zroot/vm 2> "/dev/null" || true
${ELEVATE} vm init 2> "/dev/null" || true
${ELEVATE} vm switch create public 2> "/dev/null" || true
${ELEVATE} vm switch address public 192.168.8.1/24 2> "/dev/null" || true
${ELEVATE} vm switch remove public re0 2> "/dev/null" || true
${ELEVATE} ifconfig vm-public deletem re0 2> "/dev/null" || true

cat <<- "EOF" | ${ELEVATE} tee /etc/pf.conf > "/dev/null"
wired_if = "re0"
wifi_if  = "wlan0"
vm_if    = "vm-public"
vm_net   = "192.168.8.0/24"
jail_net = "192.168.10.0/24"

table <jails> persist
table <cni-nat> persist

set block-policy return
set skip on { lo, vm-switch, bastille0 }

scrub in all fragment reassemble

### --------------------------------
### TRANSLATION
### --------------------------------
nat-anchor "cni-rdr/*"
rdr-anchor "cni-rdr/*"
rdr-anchor "rdr/*"

nat on $wired_if inet from { $vm_net, $jail_net, <jails>, <cni-nat> } to any -> ($wired_if:0)
nat on $wifi_if  inet from { $vm_net, $jail_net, <jails>, <cni-nat> } to any -> ($wifi_if:0)

### --------------------------------
### FILTERING
### --------------------------------
block in all
pass out quick all keep state

anchor "bastille/*"

pass quick on $vm_if all
pass quick on cni-podman0 all

pass in quick inet proto udp from any port 67 to any port 68
pass in quick inet proto icmp all
pass in quick inet6 proto ipv6-icmp all
EOF

if command -v pfctl > "/dev/null" 2>&1; then
	${ELEVATE} pfctl -nf /etc/pf.conf > "/dev/null" 2>&1 && ${ELEVATE} service pf reload > "/dev/null" 2>&1 || true
fi

### --------------------------------
### 5. EXPORTACAO NFSV3
### --------------------------------
if [ -d "/home/gabrielf" ] && ! grep -q "/home/gabrielf.*192.168.8.2" /etc/exports 2> "/dev/null"; then
	echo "/home/gabrielf -alldirs -mapall=gabrielf 192.168.8.2" | ${ELEVATE} tee -a /etc/exports > "/dev/null"
	${ELEVATE} service mountd reload 2> "/dev/null" || true
fi

### --------------------------------
### 6. CALCULO DE MEMORIA
### --------------------------------
RAW_BYTES="$(sysctl -n hw.realmem 2> "/dev/null" || sysctl -n hw.physmem 2> "/dev/null" || echo 0)"
VM_MEM_GB=1
if [ "${RAW_BYTES}" -gt 0 ] 2> "/dev/null"; then
	TOTAL_GB="$(echo "${RAW_BYTES}" | awk '{ printf "%.0f\n", $1 / 1073741824 }')"
	[ "${TOTAL_GB}" -lt 1 ] && TOTAL_GB=1
	VM_MEM_GB=$(( TOTAL_GB * 1 / 16 ))
	[ "${VM_MEM_GB}" -lt 1 ] && VM_MEM_GB=1
	[ "${VM_MEM_GB}" -gt 2 ] && VM_MEM_GB=2
fi

### --------------------------------
### 7. TEMPLATE BHYVE DEBIAN
### --------------------------------
${ELEVATE} mkdir -p /zroot/vm/.templates
cat <<- EOF | ${ELEVATE} tee /zroot/vm/.templates/debian.conf > "/dev/null"
	loader="uefi"
	cpu=4
	memory=${VM_MEM_GB}G
	network0_type="virtio-net"
	network0_switch="public"
	disk0_type="virtio-blk"
	disk0_name="disk0.img"
	utctime="yes"
EOF

if [ -f "/zroot/vm/debian/debian.conf" ]; then
	${ELEVATE} sed -i '' "s/^memory=.*/memory=${VM_MEM_GB}G/" "/zroot/vm/debian/debian.conf" 2> "/dev/null" || \
		${ELEVATE} sed -i "s/^memory=.*/memory=${VM_MEM_GB}G/" "/zroot/vm/debian/debian.conf" 2> "/dev/null" || true
fi

_ui_ok "Hipervisor e ambiente de virtualização configurados com sucesso!"
