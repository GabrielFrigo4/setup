#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Universal Prettier CLI Formatter Installation
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Prettier CLI]: Instalando runtime Node e Prettier global..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

if ! command -v node > "/dev/null" 2>&1 || ! command -v npm > "/dev/null" 2>&1; then
	if command -v pkg > "/dev/null" 2>&1; then
		${ELEVATE} pkg install --yes node npm
	elif command -v dnf > "/dev/null" 2>&1; then
		${ELEVATE} dnf install --assumeyes nodejs npm
	elif command -v apt > "/dev/null" 2>&1; then
		${ELEVATE} apt install --yes nodejs npm
	elif command -v pacman > "/dev/null" 2>&1; then
		${ELEVATE} pacman -S --needed --noconfirm prettier 2> "/dev/null" || ${ELEVATE} pacman -S --needed --noconfirm nodejs npm
	fi
fi

if ! command -v prettier > "/dev/null" 2>&1 && command -v npm > "/dev/null" 2>&1; then
	${ELEVATE} npm install --global prettier
fi

echo "✅ [Prettier CLI]: Prettier configurado com sucesso!"
