#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Debian CLI Tools, Document Converters & Utilities
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Debian Tools]: Instalando utilitários essenciais de linha de comando..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} apt install --yes \
	eza \
	bat \
	fd-find \
	ripgrep \
	texlive-latex-extra \
	texlive-lang-portuguese \
	pandoc \
	weasyprint \
	imagemagick \
	ffmpeg \
	dos2unix \
	checksec \
	dirb \
	wireshark

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

if getent group wireshark > "/dev/null" 2>&1; then
	${ELEVATE} usermod --append --groups wireshark "${TARGET_USER}" 2> "/dev/null" || true
fi

if [ ! -f "/etc/apt/sources.list.d/dbeaver.list" ]; then
	${ELEVATE} mkdir -p "/usr/share/keyrings"
	curl -fsSL "https://dbeaver.io/debs/dbeaver.gpg.key" | \
		${ELEVATE} gpg --dearmor --yes -o "/usr/share/keyrings/dbeaver.gpg.key" 2> "/dev/null" || true
	echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | \
		${ELEVATE} tee "/etc/apt/sources.list.d/dbeaver.list" > "/dev/null"
	${ELEVATE} apt update 2> "/dev/null" || true
	${ELEVATE} apt install --yes dbeaver-ce 2> "/dev/null" || true
fi

echo "✅ [Debian Tools]: Utilitários instalados com sucesso!"
