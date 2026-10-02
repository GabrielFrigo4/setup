#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Modern CLI Utilities
# ----------------------------------------------------------------
set -eu

echo "📦 [CLI]: Instalando utilitários essenciais de terminal..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		bat \
		eza \
		fd-find \
		ripgrep \
		zoxide \
		fastfetch
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		bat \
		eza \
		fd-find \
		ripgrep \
		zoxide \
		fastfetch
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		bat \
		eza \
		fd-find \
		ripgrep \
		zoxide 2> "/dev/null" || true

	mkdir -p "/usr/local/bin"
	if command -v batcat > "/dev/null" 2>&1 && [ ! -f "/usr/local/bin/bat" ]; then
		cat <<- 'EOF' | ${ELEVATE} tee "/usr/local/bin/bat" > "/dev/null"
			#!/usr/bin/env sh
			batcat "$@"
		EOF
		${ELEVATE} chmod 0755 "/usr/local/bin/bat"
	fi
	if command -v fdfind > "/dev/null" 2>&1 && [ ! -f "/usr/local/bin/fd" ]; then
		cat <<- 'EOF' | ${ELEVATE} tee "/usr/local/bin/fd" > "/dev/null"
			#!/usr/bin/env sh
			fdfind "$@"
		EOF
		${ELEVATE} chmod 0755 "/usr/local/bin/fd"
	fi
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-bat \
			mingw-w64-ucrt-x86_64-eza \
			mingw-w64-ucrt-x86_64-fd \
			mingw-w64-ucrt-x86_64-ripgrep \
			mingw-w64-ucrt-x86_64-zoxide \
			mingw-w64-ucrt-x86_64-fastfetch
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			bat \
			eza \
			fd \
			ripgrep \
			zoxide \
			fastfetch
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id eza-community.eza --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id sharkdp.bat --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id BurntSushi.ripgrep.MSVC --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id sharkdp.fd --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id ajeetdsouza.zoxide --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id Fastfetch-cli.Fastfetch --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	echo "❌ [CLI]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [CLI]: Utilitários de terminal instalados com sucesso!"
