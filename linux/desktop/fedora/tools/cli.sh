#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Terminal UI Frameworks (FTXUI / Notcurses)
# ----------------------------------------------------------------
set -eu

echo "📦 [Fedora TUI]: Instalando bibliotecas de Terminal UI..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} dnf install --assumeyes ftxui notcurses zoxide

echo "✅ [Fedora TUI]: Utilitários CLI e bibliotecas TUI instalados!"
