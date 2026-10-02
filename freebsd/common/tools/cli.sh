#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Universal CLI & System Tools
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD CLI]: Instalando utilitários essenciais de terminal..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes \
	bash \
	zsh \
	curl \
	wget \
	wget2 \
	git \
	got \
	git-credential-oauth \
	gh \
	mandoc \
	eza \
	bat \
	ripgrep \
	fd-find \
	grex \
	zoxide \
	zip \
	unzip \
	7-zip \
	unrar \
	git-lfs \
	pdftk \
	texlive-full \
	fastfetch \
	cpufetch

if ! command -v uv > "/dev/null" 2>&1; then
	echo "  ↳ Instalando Astral uv (Fast Python Package Manager)..."
	${ELEVATE} pkg install --yes py311-uv 2> "/dev/null" || ${ELEVATE} pkg install --yes uv 2> "/dev/null" || {
		curl -LsSf https://astral.sh/uv/install.sh | sh
	}
fi

echo "✅ [FreeBSD CLI]: Utilitários instalados com sucesso!"
