#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Document Processing & Typesetting Tools
# ----------------------------------------------------------------
set -eu

echo "📦 [Docs]: Instalando Pandoc, TeX Live e PDFtk..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		pandoc \
		texlive-full \
		pdftk
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		pandoc \
		texlive-scheme-basic \
		pdftk 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		pandoc \
		texlive-latex-extra \
		texlive-lang-portuguese \
		pdftk 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-pandoc 2> "/dev/null" || true
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			pandoc-cli \
			texlive-basic \
			pdftk 2> "/dev/null" || true
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id JohnMacFarlane.Pandoc --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	echo "❌ [Docs]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Docs]: Ferramentas de documentos instaladas com sucesso!"
