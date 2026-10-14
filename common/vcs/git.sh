#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Git Global Configuration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if [ "$(git config --global init.defaultBranch 2> "/dev/null" || true)" = "main" ] && [ "$(git config --global core.hooksPath 2> "/dev/null" || true)" = ".githooks" ]; then
	_ui_ok "Git global já configurado com padrões canônicos."
	exit 0
fi

_ui_step "Configurando Git globalmente..."

if [ -n "${GIT_AUTHOR_NAME-}" ]; then
	git config --global user.name "${GIT_AUTHOR_NAME}"
fi

if [ -n "${GIT_AUTHOR_EMAIL-}" ]; then
	git config --global user.email "${GIT_AUTHOR_EMAIL}"
fi

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.quotepath false
git config --global core.hooksPath .githooks

_ui_ok "Git configurado com sucesso!"
