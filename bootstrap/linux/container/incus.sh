#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Linux Universal Incus & LXC System Containers Setup
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Linux Incus]: Configurando containers de sistema Incus e LXC..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes incus 2> "/dev/null" || true
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes incus lxc 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm incus lxc 2> "/dev/null" || true
fi

${ELEVATE} systemctl enable --now lxc-net.service 2> "/dev/null" || true
${ELEVATE} systemctl enable --now lxc.service 2> "/dev/null" || true
${ELEVATE} systemctl enable --now incus.socket 2> "/dev/null" || true
${ELEVATE} usermod --append --groups incus-admin "${TARGET_USER}" 2> "/dev/null" || true

if ! grep -q "^root:100000:65536" "/etc/subuid" 2> "/dev/null"; then
	echo "root:100000:65536" | ${ELEVATE} tee -a "/etc/subuid" > "/dev/null"
fi

if ! grep -q "^root:100000:65536" "/etc/subgid" 2> "/dev/null"; then
	echo "root:100000:65536" | ${ELEVATE} tee -a "/etc/subgid" > "/dev/null"
fi

${ELEVATE} systemctl restart incus 2> "/dev/null" || true

echo "✅ [Linux Incus]: Containers Incus configurados com sucesso!"
