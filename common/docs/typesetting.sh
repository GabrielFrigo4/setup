#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Document Processing & Typesetting Tools
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v pandoc > "/dev/null" 2>&1 && command -v pdftk > "/dev/null" 2>&1; then
	_ui_ok "Ferramentas de diagramação (Pandoc, PDFtk) já instaladas."
	exit 0
fi

_ui_step "Instalando Pandoc, TeX Live e PDFtk..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		textproc/hs-pandoc \
		print/texlive-full \
		print/pdftk
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
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Ferramentas de documentos instaladas com sucesso!"
