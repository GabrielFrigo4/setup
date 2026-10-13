#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Tmux Terminal Multiplexer
# ----------------------------------------------------------------
set -eu

echo "📦 [Tmux]: Instalando o multiplexador de terminal tmux..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes sysutils/tmux
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes tmux
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes tmux
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S tmux
	else
		${ELEVATE} pacman -S --needed --noconfirm tmux
	fi
elif command -v apk > "/dev/null" 2>&1; then
	${ELEVATE} apk add --no-cache tmux
elif command -v xbps-install > "/dev/null" 2>&1; then
	${ELEVATE} xbps-install -Sy tmux
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id tmux.tmux --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	echo "❌ [Tmux]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Tmux]: Multiplexador tmux instalado com sucesso!"
