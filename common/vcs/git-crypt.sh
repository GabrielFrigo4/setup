#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Git-Crypt Transparent Git Encryption Tool
# ----------------------------------------------------------------
set -eu

echo "📦 [git-crypt]: Instalando git-crypt..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v git-crypt > "/dev/null" 2>&1; then
	echo "✅ [git-crypt]: git-crypt já está instalado."
	exit 0
fi

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes git-crypt
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes git-crypt
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm git-crypt
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq
	${ELEVATE} apt-get install --yes git-crypt
elif command -v brew > "/dev/null" 2>&1; then
	brew install git-crypt
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install git-crypt
else
	echo "⚠️  [git-crypt]: Gerenciador de pacotes não suportado."
	exit 1
fi

echo "✅ [git-crypt]: Instalado com sucesso!"
