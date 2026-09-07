#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Terminal UI Frameworks (FTXUI / Notcurses)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Fedora TUI]: Instalando bibliotecas de Terminal UI..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} dnf install --assumeyes ftxui notcurses

echo "✅ [Fedora TUI]: Bibliotecas FTXUI e Notcurses instaladas!"
