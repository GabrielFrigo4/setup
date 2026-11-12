#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: ZFS ARC Dynamic Memory Limiter & Host/VM Tuning
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Calculando limites dinâmicos de memória ZFS ARC..."

### --------------------------------
### 1. DETECCAO DE MEMORIA FISICA
### --------------------------------
RAW_BYTES="$(sysctl -n hw.realmem 2> "/dev/null" || sysctl -n hw.physmem 2> "/dev/null" || echo 0)"

if [ "${RAW_BYTES}" -le 0 ]; then
	_ui_warn "Não foi possível detectar memória física. Pulando ajuste."
	exit 0
fi

TOTAL_GB="$(echo "${RAW_BYTES}" | awk '{ printf "%.0f\n", $1 / 1073741824 }')"
[ "${TOTAL_GB}" -lt 1 ] && TOTAL_GB=1

### --------------------------------
### 2. PROPORCAO DE MEMORIA
### --------------------------------
ARC_MAX_GB=$(( TOTAL_GB * 4 / 16 ))
[ "${ARC_MAX_GB}" -lt 1 ] && ARC_MAX_GB=1
[ "${ARC_MAX_GB}" -gt 4 ] && ARC_MAX_GB=4

VM_MEM_GB=$(( TOTAL_GB * 1 / 16 ))
[ "${VM_MEM_GB}" -lt 1 ] && VM_MEM_GB=1
[ "${VM_MEM_GB}" -gt 2 ] && VM_MEM_GB=2

HOST_MEM_GB=$(( TOTAL_GB - ARC_MAX_GB - VM_MEM_GB ))
[ "${HOST_MEM_GB}" -lt 1 ] && HOST_MEM_GB=1

ARC_MAX_BYTES=$(( ARC_MAX_GB * 1024 * 1024 * 1024 ))
ARC_MIN_BYTES=1073741824
if [ "${ARC_MAX_BYTES}" -le "${ARC_MIN_BYTES}" ]; then
	ARC_MIN_BYTES=$(( ARC_MAX_BYTES / 2 ))
fi
if [ "${ARC_MIN_BYTES}" -gt "${ARC_MAX_BYTES}" ]; then
	ARC_MIN_BYTES="${ARC_MAX_BYTES}"
fi
VM_MEM_BYTES=$(( VM_MEM_GB * 1024 * 1024 * 1024 ))
HOST_MEM_BYTES=$(( HOST_MEM_GB * 1024 * 1024 * 1024 ))

_ui_info "RAM Total: ${TOTAL_GB} GB"
_ui_sub "ZFS ARC Max: ${ARC_MAX_GB} GB (${ARC_MAX_BYTES} bytes)"
_ui_sub "Host FreeBSD: ${HOST_MEM_GB} GB"
_ui_sub "Bhyve VM Guest: ${VM_MEM_GB} GB"

### --------------------------------
### 3. AJUSTE IMEDIATO EM RUNTIME
### --------------------------------
${ELEVATE} sysctl vfs.zfs.arc.max="${ARC_MAX_BYTES}" > "/dev/null" 2>&1 || true
${ELEVATE} sysctl vfs.zfs.arc.min="${ARC_MIN_BYTES}" > "/dev/null" 2>&1 || true

### --------------------------------
### 4. LIMPEZA DE TUNABLES RESIDUAIS
### --------------------------------
for _cfg in "/etc/sysctl.conf" "/boot/loader.conf" "/boot/loader.conf.local"; do
	if [ -f "${_cfg}" ]; then
		${ELEVATE} sed -i '' -e '/#.*ZFS ARC/d' -e '/vfs\.zfs\.arc_max/d' -e '/vfs\.zfs\.arc\.max/d' -e '/vfs\.zfs\.arc\.min/d' -e '/vfs\.zfs\.txg\.timeout/d' "${_cfg}" 2> "/dev/null" || true
	fi
done

if [ -d "/boot/loader.conf.d" ]; then
	for _cfg in /boot/loader.conf.d/*; do
		if [ -f "${_cfg}" ]; then
			${ELEVATE} sed -i '' -e '/#.*ZFS ARC/d' -e '/vfs\.zfs\.arc_max/d' -e '/vfs\.zfs\.arc\.max/d' -e '/vfs\.zfs\.arc\.min/d' -e '/vfs\.zfs\.txg\.timeout/d' "${_cfg}" 2> "/dev/null" || true
		fi
	done
fi

### --------------------------------
### 5. PERSISTENCIA EM SYSCTL.CONF
### --------------------------------
if [ -f "/etc/sysctl.conf" ]; then
	cat <<- EOF | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
	vfs.zfs.arc.max=${ARC_MAX_BYTES}
	vfs.zfs.arc.min=${ARC_MIN_BYTES}
	EOF
fi

### --------------------------------
### 6. PERSISTENCIA EM LOADER.CONF
### --------------------------------
if [ -f "/boot/loader.conf" ]; then
	cat <<- EOF | ${ELEVATE} tee -a "/boot/loader.conf" > "/dev/null"
	vfs.zfs.arc.max="${ARC_MAX_BYTES}"
	vfs.zfs.arc.min="${ARC_MIN_BYTES}"
	vfs.zfs.txg.timeout="10"
	EOF
fi

### --------------------------------
### 7. ALINHAMENTO TEMPLATE BHYVE
### --------------------------------
if [ "${VM_MEM_GB}" -ge 1 ]; then
	for _vm_conf in "/zroot/vm/.templates/debian.conf" "/zroot/vm/debian/debian.conf"; do
		if [ -f "${_vm_conf}" ]; then
			${ELEVATE} sed -i '' "s/^memory=.*/memory=${VM_MEM_GB}G/" "${_vm_conf}" 2> "/dev/null" || true
		fi
	done
fi

### --------------------------------
### 8. DIAGNOSTICO DO ZFS ARC
### --------------------------------
if ! pkg info -e py-sysctl > "/dev/null" 2>&1 || ! pkg info -e arc_summary > "/dev/null" 2>&1 || ! pkg info -e zfs-stats > "/dev/null" 2>&1; then
	_ui_step "Instalando utilitários de diagnóstico e py-sysctl..."
	${ELEVATE} pkg install -y devel/py-sysctl sysutils/arc_summary sysutils/zfs-stats 2> "/dev/null" || true
fi

if [ ! -f "/usr/local/bin/arcstat" ]; then
	if command -v fetch > "/dev/null" 2>&1; then
		_ui_sub "Instalando arcstat OpenZFS..."
		fetch -qo - "https://raw.githubusercontent.com/openzfs/zfs/master/cmd/arcstat/arcstat.in" 2> "/dev/null" | \
			sed 's|@PYTHON_SHEBANG@|#!/usr/bin/env python3|g' | \
			${ELEVATE} tee "/usr/local/bin/arcstat" > "/dev/null" 2>&1 || true
		${ELEVATE} chmod 0755 "/usr/local/bin/arcstat" 2> "/dev/null" || true
	fi
fi

_ui_ok "Limite superior do ARC configurado em ${ARC_MAX_GB} GB!"
exit 0
