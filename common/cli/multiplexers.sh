#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Terminal Multiplexers Suite (Tmux & Zellij)
# ----------------------------------------------------------------
set -eu

echo "📦 [Multiplexers]: Provisionando suite de multiplexadores de terminal..."

_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "${_DIR}/tmux.sh" ]; then
	sh "${_DIR}/tmux.sh"
fi

if [ -f "${_DIR}/zellij.sh" ]; then
	sh "${_DIR}/zellij.sh"
fi

echo "✅ [Multiplexers]: Suite de multiplexadores provisionada com sucesso!"
