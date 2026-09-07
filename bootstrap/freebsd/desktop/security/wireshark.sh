#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Wireshark Packet Capture
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Wireshark]: Instalando e configurando captura de pacotes..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} pkg install --yes wireshark

DEVFS_CONF="/etc/devfs.rules"
if [ ! -f "${DEVFS_CONF}" ]; then
	${ELEVATE} touch "${DEVFS_CONF}"
fi

if ! grep -q "own.*bpf" "${DEVFS_CONF}" 2> "/dev/null"; then
	cat <<- 'EOF' | ${ELEVATE} tee -a "${DEVFS_CONF}" > "/dev/null"

	[system=10]
	add path 'bpf*' mode 0660 group wheel
	EOF
	${ELEVATE} sysrc devfs_system_ruleset="system"
	${ELEVATE} service devfs restart > "/dev/null" 2>&1 || true
fi

${ELEVATE} pw groupmod wheel -m "${TARGET_USER}" 2> "/dev/null" || true

echo "✅ [FreeBSD Wireshark]: Configurado! Usuário '${TARGET_USER}' autorizado a capturar via BPF."
