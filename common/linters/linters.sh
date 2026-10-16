#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common Developer Tools & Linters Configuration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if [ -f "${HOME}/.clang-format" ] && [ -f "${HOME}/.prettierrc" ] && [ -f "${HOME}/.stylua.toml" ] && [ -f "${HOME}/.config/ruff/ruff.toml" ]; then
	_ui_ok "Formatadores e linters globais já configurados."
	exit 0
fi

_ui_step "Configurando formatadores e linters globais..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_TOOLS_DIR="${SCRIPT_DIR}/../../../Profile/tools"
RAW_BASE_URL="https://raw.githubusercontent.com/GabrielFrigo4/profile/main/tools"

mkdir -p "${HOME}/.config/clangd" "${HOME}/.config/ruff"

sync_file() {
	_src_name="$1"
	_dest_path="$2"
	_local_file="${LOCAL_TOOLS_DIR}/${_src_name}"
	_raw_url="${RAW_BASE_URL}/${_src_name}"

	if [ -f "${_local_file}" ]; then
		cp "${_local_file}" "${_dest_path}"
	else
		curl -fsSL "${_raw_url}" -o "${_dest_path}"
	fi
}

sync_file ".clang-format" "${HOME}/.clang-format"
sync_file "clangd.yaml" "${HOME}/.config/clangd/config.yaml"
sync_file ".prettierrc" "${HOME}/.prettierrc"
sync_file ".stylua.toml" "${HOME}/.stylua.toml"
sync_file "ruff.toml" "${HOME}/.config/ruff/ruff.toml"
sync_file "mermaid-puppeteer.json" "${HOME}/.mermaid-puppeteer-config.json"
sync_file "mermaid-theme.json" "${HOME}/.mermaid-theme-config.json"

_ui_ok "Formatadores (.clang-format, clangd, prettier, stylua, ruff, mermaid) configurados!"
