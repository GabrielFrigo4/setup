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
RAW_BYTES="$(sysctl -n hw.realmem 2> "/dev/null" || sysctl -n hw.physmem 2> "/dev/null" || echo 0)"

if [ "${RAW_BYTES}" -le 0 ]; then
	echo "⚠️  [ZFS ARC]: Não foi possível detectar memória física. Pulando ajuste."
	exit 0
fi

TOTAL_GB="$(echo "${RAW_BYTES}" | awk '{ printf "%.0f\n", $1 / 1073741824 }')"
[ "${TOTAL_GB}" -lt 1 ] && TOTAL_GB=1

### --------------------------------
### 2. Proporcao de Memoria
### --------------------------------
ARC_MAX_GB=$(( TOTAL_GB * 4 / 8 ))
HOST_MEM_GB=$(( TOTAL_GB * 3 / 8 ))
VM_MEM_GB=$(( TOTAL_GB * 1 / 8 ))

[ "${VM_MEM_GB}" -lt 1 ] && VM_MEM_GB=1
[ "${ARC_MAX_GB}" -lt 1 ] && ARC_MAX_GB=1

ARC_MAX_BYTES=$(( ARC_MAX_GB * 1024 * 1024 * 1024 ))
VM_MEM_BYTES=$(( VM_MEM_GB * 1024 * 1024 * 1024 ))
HOST_MEM_BYTES=$(( HOST_MEM_GB * 1024 * 1024 * 1024 ))

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
		${ELEVATE} sed -i '' -e '/#.*ZFS ARC/d' -e '/vfs\.zfs\.arc/d' "/etc/sysctl.conf" 2> "/dev/null" || true
	fi
	cat <<- EOF | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"

		# Default ZFS ARC Cache
		vfs.zfs.arc_max=${ARC_MAX_BYTES}
	EOF
fi

### --------------------------------
### 5. Persistencia em loader.conf
### --------------------------------
if [ -f "/boot/loader.conf" ]; then
	if grep -q "vfs.zfs.arc" "/boot/loader.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' -e '/#.*ZFS ARC/d' -e '/vfs\.zfs\.arc/d' "/boot/loader.conf" 2> "/dev/null" || true
	fi
	cat <<- EOF | ${ELEVATE} tee -a "/boot/loader.conf" > "/dev/null"

		# Default ZFS ARC Cache
		vfs.zfs.arc_max="${ARC_MAX_BYTES}"
	EOF
fi

### --------------------------------
### 6. Alinhamento Template Bhyve
### --------------------------------
if [ -f "/zroot/vm/.templates/debian.conf" ] && [ "${VM_MEM_GB}" -ge 1 ]; then
	${ELEVATE} sed -i '' "s/^memory=.*/memory=${VM_MEM_GB}G/" "/zroot/vm/.templates/debian.conf" 2> "/dev/null" || true
fi

### --------------------------------
### 7. Diagnostico do ZFS ARC
### --------------------------------
echo "📦 [ZFS ARC]: Instalando utilitários de diagnóstico e py-sysctl..."
${ELEVATE} pkg install --yes py312-sysctl arc_summary zfs-stats 2> "/dev/null" || \
	${ELEVATE} pkg install --yes py312-sysctl arc_summary zfs-stats 2> "/dev/null" || true

if [ ! -f "/usr/local/bin/arcstat" ]; then
	if command -v fetch > "/dev/null" 2>&1; then
		echo "   ➕ Instalando arcstat OpenZFS..."
		fetch -qo - "https://raw.githubusercontent.com/openzfs/zfs/master/cmd/arcstat/arcstat.in" 2> "/dev/null" | \
			sed 's|@PYTHON_SHEBANG@|#!/usr/bin/env python3|g' | \
			${ELEVATE} tee "/usr/local/bin/arcstat" > "/dev/null" 2>&1 || true
		${ELEVATE} chmod 0755 "/usr/local/bin/arcstat" 2> "/dev/null" || true
	fi
fi

echo "✅ [ZFS ARC]: Limite superior do ARC configurado em ${ARC_MAX_GB} GB!"
exit 0
