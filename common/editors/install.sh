#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Code Editors Package Installation
# ----------------------------------------------------------------
set -eu

echo "📦 [Editors]: Instalando editores de código (Neovim, Vim, Emacs, Helix, Micro)..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		neovim \
		vim \
		emacs \
		helix \
		micro
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		neovim \
		vim-enhanced \
		emacs \
		helix \
		micro 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		neovim \
		vim \
		emacs \
		micro 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes helix 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-emacs \
			mingw-w64-ucrt-x86_64-micro
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			neovim \
			vim \
			emacs \
			helix \
			micro
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Neovim.Neovim --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id Helix.Helix --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id zyedidia.micro --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	echo "❌ [Editors]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Editors]: Editores de código instalados com sucesso!"
