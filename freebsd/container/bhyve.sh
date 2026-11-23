#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Bhyve Virtualization Manager & Debian Host
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando hipervisor Bhyve e rede virtual..."

_detect_wired_if() {
	_def="$(route -n get default 2> "/dev/null" | awk '/interface:/ {print $2; exit}' || true)"
	case "${_def}" in
		""|wlan*|lo*|vm-*|bastille*|pflog*|enc*|tap*|tun*|bridge*|epair*|cni-*) ;;
		*) printf "%s\n" "${_def}"; return 0 ;;
	esac
	for _if in $(ifconfig -l 2> "/dev/null" || true); do
		case "${_if}" in
			lo*|wlan*|vm-*|bastille*|pflog*|enc*|tap*|tun*|bridge*|epair*|cni-*) continue ;;
			*) printf "%s\n" "${_if}"; return 0 ;;
		esac
	done
	printf "re0\n"
}

_detect_wifi_if() {
	for _if in $(ifconfig -l 2> "/dev/null" || true); do
		case "${_if}" in
			wlan*) printf "%s\n" "${_if}"; return 0 ;;
		esac
	done
	printf "wlan0\n"
}

ZFS_POOL="${ZFS_POOL:-$(zpool list -H -o name 2> "/dev/null" | head -n 1 || true)}"
: "${ZFS_POOL:=zroot}"
WIRED_IF="${WIRED_IF:-$(_detect_wired_if)}"
WIFI_IF="${WIFI_IF:-$(_detect_wifi_if)}"
VM_NET="${VM_NET:-192.168.8.0/24}"
JAIL_NET="${JAIL_NET:-192.168.10.0/24}"
VM_SWITCH_ADDR="${VM_SWITCH_ADDR:-${VM_NET%.*}.1/${VM_NET#*/}}"
VM_GUEST_IP="${VM_GUEST_IP:-${VM_NET%.*}.2}"

### --------------------------------
### 1. PACOTES E FIRMWARE
### --------------------------------
${ELEVATE} pkg install --yes sysutils/vm-bhyve sysutils/bhyve-firmware net/tigervnc-viewer

### --------------------------------
### 2. PERSISTENCIA DE SERVICOS
### --------------------------------
${ELEVATE} sysrc vm_enable="YES"
${ELEVATE} sysrc vm_dir="zfs:${ZFS_POOL}/vm"
${ELEVATE} sysrc vm_list=""
${ELEVATE} sysrc gateway_enable="YES"
${ELEVATE} sysrc pf_enable="YES"
${ELEVATE} sysrc pflog_enable="YES"
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
${ELEVATE} zfs create -o mountpoint="/${ZFS_POOL}/vm" "${ZFS_POOL}/vm" 2> "/dev/null" || true
${ELEVATE} vm init 2> "/dev/null" || true
${ELEVATE} vm switch create public 2> "/dev/null" || true
${ELEVATE} vm switch address public "${VM_SWITCH_ADDR}" 2> "/dev/null" || true
${ELEVATE} vm switch remove public "${WIRED_IF}" 2> "/dev/null" || true
${ELEVATE} ifconfig vm-public deletem "${WIRED_IF}" 2> "/dev/null" || true

{
	cat <<- EOF
	wired_if = "${WIRED_IF}"
	wifi_if  = "${WIFI_IF}"
	vm_if    = "vm-public"
	vm_net   = "${VM_NET}"
	jail_net = "${JAIL_NET}"
	EOF
	cat <<- "EOF"

	table <jails> persist
	table <cni-nat> persist
	table <bruteforce> persist
	table <lan_nets> const { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, fc00::/7, fe80::/10 }

	### --------------------------------
	### OPTIONS
	### --------------------------------
	set block-policy drop
	set state-policy if-bound
	set skip on { lo0, bastille0 }
	set reassemble yes
	set syncookies adaptive (start 25%, end 12%)

	### --------------------------------
	### TRANSLATION
	### --------------------------------
	nat-anchor "cni-rdr/*"
	rdr-anchor "cni-rdr/*"
	rdr-anchor "rdr/*"

	### --------------------------------
	### FILTERING
	### --------------------------------
	match in all scrub (no-df random-id max-mss 1440)
	match out on $wired_if inet from { $vm_net, $jail_net, <jails>, <cni-nat> } to any nat-to ($wired_if:0)
	match out on $wifi_if  inet from { $vm_net, $jail_net, <jails>, <cni-nat> } to any nat-to ($wifi_if:0)

	block in log all
	block return in log on $wired_if from <lan_nets>
	block return in log on $vm_if

	block drop log quick from <bruteforce>
	block drop in log quick on { $wired_if, $wifi_if } from { 127.0.0.0/8, ::1 }

	pass quick on { $wired_if, $wifi_if } inet proto igmp allow-opts
	pass out quick all

	pass in quick inet proto udp from any port 67 to any port 68
	pass in quick on $vm_if inet proto udp from any port 68 to any port 67
	pass in quick inet proto icmp all
	pass in quick inet6 proto ipv6-icmp all

	block drop in log quick from urpf-failed

	anchor "bastille/*"
	anchor "dev/*"

	pass in quick on $vm_if from $vm_net to ($vm_if)
	pass in quick on { $vm_if, cni-podman0 } proto { tcp, udp } to any port 53
	pass in quick on cni-podman0 from <cni-nat> to (cni-podman0:network)
	block return in log quick on { $vm_if, cni-podman0 } to <lan_nets>
	pass in quick on { $vm_if, cni-podman0 } all

	pass in quick on { $wired_if, $wifi_if } proto { tcp, udp } from <lan_nets> to any port 1714:1764
	pass in quick on { $wired_if, $wifi_if } proto udp from <lan_nets> to any port 5353
	pass in quick on { $wired_if, $wifi_if } proto udp from <lan_nets> port 5353 to any
	pass in quick on { $wired_if, $wifi_if } proto tcp from <lan_nets> to any port 22 keep state (max-src-conn 15, max-src-conn-rate 15/30, overload <bruteforce> flush global)
	EOF
} | ${ELEVATE} tee /etc/pf.conf > "/dev/null"

if command -v pfctl > "/dev/null" 2>&1; then
	${ELEVATE} pfctl -nf /etc/pf.conf
	${ELEVATE} service pflog status > "/dev/null" 2>&1 || ${ELEVATE} service pflog start > "/dev/null" 2>&1 || true
	${ELEVATE} service pf reload > "/dev/null" 2>&1 || true
fi

### --------------------------------
### 5. EXPORTACAO NFSV3
### --------------------------------
_host_user="${HOST_USER:-${SUDO_USER:-${DOAS_USER:-${USER:-$(id -un)}}}}"
_host_home="${HOST_HOME:-$(awk -F: -v u="${_host_user}" '$1 == u { print $6; exit }' /etc/passwd 2> "/dev/null" || echo "${HOME}")}"
if [ "${_host_user}" != "root" ] && [ -n "${_host_home}" ] && [ -d "${_host_home}" ] && ! grep -q "${_host_home}.*${VM_GUEST_IP}" /etc/exports 2> "/dev/null"; then
	echo "${_host_home} -alldirs -mapall=${_host_user} ${VM_GUEST_IP}" | ${ELEVATE} tee -a /etc/exports > "/dev/null"
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
${ELEVATE} mkdir -p "/${ZFS_POOL}/vm/.templates"
cat <<- EOF | ${ELEVATE} tee "/${ZFS_POOL}/vm/.templates/debian.conf" > "/dev/null"
	loader="uefi"
	cpu=4
	memory=${VM_MEM_GB}G
	network0_type="virtio-net"
	network0_switch="public"
	disk0_type="virtio-blk"
	disk0_name="disk0.img"
	utctime="yes"
EOF

if [ -f "/${ZFS_POOL}/vm/debian/debian.conf" ]; then
	${ELEVATE} sed -i '' "s/^memory=.*/memory=${VM_MEM_GB}G/" "/${ZFS_POOL}/vm/debian/debian.conf" 2> "/dev/null" || \
		${ELEVATE} sed -i "s/^memory=.*/memory=${VM_MEM_GB}G/" "/${ZFS_POOL}/vm/debian/debian.conf" 2> "/dev/null" || true
	if grep -q '^graphics="yes"' "/${ZFS_POOL}/vm/debian/debian.conf" 2> "/dev/null" && ! grep -q '^graphics_listen=' "/${ZFS_POOL}/vm/debian/debian.conf" 2> "/dev/null"; then
		echo 'graphics_listen="127.0.0.1"' | ${ELEVATE} tee -a "/${ZFS_POOL}/vm/debian/debian.conf" > "/dev/null"
	fi
fi

_ui_ok "Hipervisor e ambiente de virtualização configurados com sucesso!"
