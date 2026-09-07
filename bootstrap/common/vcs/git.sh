#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Git Global Configuration
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Git]: Configurando Git globalmente..."

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

echo "✅ [Git]: Configurado com sucesso!"
