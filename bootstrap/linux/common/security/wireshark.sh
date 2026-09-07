#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Linux Universal Wireshark Packet Capture
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Linux Wireshark]: Instalando Wireshark e configurando permissões..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes wireshark wireshark-cli
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes wireshark tshark
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm wireshark-qt wireshark-cli
fi

if getent group wireshark > "/dev/null" 2>&1; then
	${ELEVATE} usermod --append --groups wireshark "${TARGET_USER}"
fi

echo "✅ [Linux Wireshark]: Concluído! Usuário '${TARGET_USER}' configurado para captura de pacotes."
