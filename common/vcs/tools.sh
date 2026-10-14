#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Version Control Tools (Git, Got & GitHub CLI)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v git > "/dev/null" 2>&1 && command -v gh > "/dev/null" 2>&1 && command -v git-lfs > "/dev/null" 2>&1; then
	_ui_ok "Ferramentas principais de VCS (git, gh, git-lfs) já instaladas."
	exit 0
fi

_ui_step "Instalando Git, GitHub CLI e ferramentas de controle de versão..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		devel/git \
		devel/got \
		security/git-credential-oauth \
		devel/gh \
		devel/git-lfs
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		git \
		gh \
		git-lfs
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		git \
		gh \
		git-lfs 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-git \
			mingw-w64-ucrt-x86_64-github-cli
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			git \
			github-cli \
			git-lfs
		if command -v yay > "/dev/null" 2>&1; then
			yay -S --needed --noconfirm got-portable 2> "/dev/null" || true
		fi
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Git.Git --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id GitHub.cli --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Ferramentas de versionamento instaladas com sucesso!"
