#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: ZFS ARC Dynamic Memory Limiter & Host/VM Tuning
# ----------------------------------------------------------------
set -eu

echo "📦 [ZFS ARC]: Calculando limites dinâmicos de memória..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

### --------------------------------
### 1. Deteccao de Memoria Fisica
### --------------------------------
TOTAL_MEM_BYTES="$(sysctl -n hw.physmem 2> "/dev/null" || sysctl -n hw.realmem 2> "/dev/null" || echo 0)"

if [ "${TOTAL_MEM_BYTES}" -le 0 ]; then
	echo "⚠️  [ZFS ARC]: Não foi possível detectar hw.physmem. Pulando ajuste."
	exit 0
fi

### --------------------------------
### 2. Proporcao de Memoria
### --------------------------------
ARC_MAX_BYTES=$(( TOTAL_MEM_BYTES * 4 / 8 ))
VM_MEM_BYTES=$(( TOTAL_MEM_BYTES * 1 / 8 ))
HOST_MEM_BYTES=$(( TOTAL_MEM_BYTES * 3 / 8 ))

TOTAL_GB=$(( TOTAL_MEM_BYTES / 1024 / 1024 / 1024 ))
ARC_MAX_GB=$(( ARC_MAX_BYTES / 1024 / 1024 / 1024 ))
VM_MEM_GB=$(( VM_MEM_BYTES / 1024 / 1024 / 1024 ))
HOST_MEM_GB=$(( HOST_MEM_BYTES / 1024 / 1024 / 1024 ))

echo "   🧠 RAM Total: ${TOTAL_GB} GB"
echo "   📊 ZFS ARC Max (4/8): ${ARC_MAX_GB} GB (${ARC_MAX_BYTES} bytes)"
echo "   🖥️  Host FreeBSD (3/8): ${HOST_MEM_GB} GB"
echo "   💻 Bhyve VM Guest (1/8): ${VM_MEM_GB} GB"

### --------------------------------
### 3. Ajuste Imediato em Runtime
### --------------------------------
${ELEVATE} sysctl vfs.zfs.arc_max="${ARC_MAX_BYTES}" > "/dev/null" 2>&1 || true
${ELEVATE} sysctl vfs.zfs.arc.max="${ARC_MAX_BYTES}" > "/dev/null" 2>&1 || true

### --------------------------------
### 4. Persistencia em sysctl.conf
### --------------------------------
if [ -f "/etc/sysctl.conf" ]; then
	if grep -q "vfs.zfs.arc" "/etc/sysctl.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' '/vfs.zfs.arc/d' "/etc/sysctl.conf" 2> "/dev/null" || true
	fi
	cat <<- EOF | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
		# ZFS ARC Cache Limit (50% da RAM fisica)
		vfs.zfs.arc_max=${ARC_MAX_BYTES}
	EOF
fi

### --------------------------------
### 5. Persistencia em loader.conf
### --------------------------------
if [ -f "/boot/loader.conf" ]; then
	if grep -q "vfs.zfs.arc" "/boot/loader.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' '/vfs.zfs.arc/d' "/boot/loader.conf" 2> "/dev/null" || true
	fi
	cat <<- EOF | ${ELEVATE} tee -a "/boot/loader.conf" > "/dev/null"
		# ZFS ARC Cache Boot Limit (50% da RAM fisica)
		vfs.zfs.arc_max="${ARC_MAX_BYTES}"
	EOF
fi

### --------------------------------
### 6. Alinhamento Template Bhyve
### --------------------------------
if [ -f "/zroot/vm/.templates/debian.conf" ] && [ "${VM_MEM_GB}" -ge 1 ]; then
	${ELEVATE} sed -i '' "s/^memory=.*/memory=${VM_MEM_GB}G/" "/zroot/vm/.templates/debian.conf" 2> "/dev/null" || true
fi

echo "✅ [ZFS ARC]: Limite superior do ARC configurado em ${ARC_MAX_GB} GB!"
exit 0
