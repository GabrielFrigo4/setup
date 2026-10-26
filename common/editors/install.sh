#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Code Editors Package Installation
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_needs_lucid=0
if command -v dnf > "/dev/null" 2>&1 || command -v apt-get > "/dev/null" 2>&1 || command -v pkg > "/dev/null" 2>&1; then
	if ! command -v emacs-lucid > "/dev/null" 2>&1; then
		_needs_lucid=1
	fi
fi

if command -v nvim > "/dev/null" 2>&1 && command -v hx > "/dev/null" 2>&1 && command -v emacs > "/dev/null" 2>&1 && [ "${_needs_lucid}" -eq 0 ]; then
	_ui_ok "Editores principais (nvim, hx, emacs, emacs-lucid) já instalados."
	exit 0
fi

_ui_step "Instalando editores de código (Neovim, Vim, Emacs, Helix, Micro)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		editors/neovim \
		editors/vim \
		editors/emacs \
		editors/emacs-lucid \
		editors/helix \
		editors/micro \
		editors/vscode 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		neovim \
		vim-enhanced \
		emacs \
		emacs-lucid \
		helix \
		micro 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		neovim \
		vim \
		emacs \
		emacs-lucid \
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
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Editores de código instalados com sucesso!"
