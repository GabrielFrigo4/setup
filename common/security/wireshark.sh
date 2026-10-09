#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Wireshark Packet Capture & Permissions
# ----------------------------------------------------------------
set -eu

echo "📦 [Wireshark]: Instalando Wireshark e configurando permissões de captura..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"
TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes wireshark
	DEVFS_CONF="/etc/devfs.rules"
	[ -f "${DEVFS_CONF}" ] || ${ELEVATE} touch "${DEVFS_CONF}"
	if ! grep -q "own.*bpf" "${DEVFS_CONF}" 2> "/dev/null"; then
		cat <<- 'EOF' | ${ELEVATE} tee -a "${DEVFS_CONF}" > "/dev/null"

		[system=10]
		add path 'bpf*' mode 0660 group wheel
		EOF
		${ELEVATE} sysrc devfs_system_ruleset="system"
		${ELEVATE} service devfs restart > "/dev/null" 2>&1 || true
	fi
	${ELEVATE} pw groupmod wheel -m "${TARGET_USER}" 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes wireshark wireshark-cli
	getent group wireshark > "/dev/null" 2>&1 && ${ELEVATE} usermod --append --groups wireshark "${TARGET_USER}" 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1 || command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes wireshark tshark 2> "/dev/null" || true
	getent group wireshark > "/dev/null" 2>&1 && ${ELEVATE} usermod --append --groups wireshark "${TARGET_USER}" 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		if command -v winget.exe > "/dev/null" 2>&1; then
			winget.exe install --id WiresharkFoundation.Wireshark --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
		fi
	else
		${ELEVATE} pacman -S --needed --noconfirm wireshark-qt wireshark-cli
		getent group wireshark > "/dev/null" 2>&1 && ${ELEVATE} usermod --append --groups wireshark "${TARGET_USER}" 2> "/dev/null" || true
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id WiresharkFoundation.Wireshark --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	echo "❌ [Wireshark]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Wireshark]: Wireshark instalado e usuário '${TARGET_USER}' autorizado para captura!"
