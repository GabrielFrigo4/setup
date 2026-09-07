#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: ePub & Document Readers
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Readers]: Instalando leitor de ePub e navegadores TUI..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes arianna w3m lynx

mkdir -p "${HOME}/.w3m"
touch "${HOME}/.w3m/history"

echo "✅ [FreeBSD Readers]: Arianna e leitores de documentos instalados com sucesso!"
