#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Version Control Tools (Git, Got & GitHub CLI)
# ----------------------------------------------------------------
set -eu

echo "📦 [VCS]: Instalando Git, GitHub CLI e ferramentas de controle de versão..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		git \
		got \
		git-credential-oauth \
		gh \
		git-lfs
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
	echo "❌ [VCS]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [VCS]: Ferramentas de versionamento instaladas com sucesso!"
