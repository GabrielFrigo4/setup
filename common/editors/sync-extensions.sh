#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Synchronize IDE Extensions
# ----------------------------------------------------------------
set -eu

find_vscode_cli() {
	if command -v code > "/dev/null" 2>&1; then
		echo "code"
	elif command -v vscode > "/dev/null" 2>&1; then
		echo "vscode"
	elif command -v code-oss > "/dev/null" 2>&1; then
		echo "code-oss"
	fi
}

find_vscodium_cli() {
	if command -v codium > "/dev/null" 2>&1; then
		echo "codium"
	elif command -v vscodium > "/dev/null" 2>&1; then
		echo "vscodium"
	fi
}

CLI=""
TARGET=""

if [ "$#" -gt 0 ] && { [ "$1" = "antigravity" ] || [ "$1" = "vscode" ] || [ "$1" = "vscodium" ]; }; then
	TARGET="$1"
	if [ "${TARGET}" = "vscode" ]; then
		CLI="$(find_vscode_cli)"
	elif [ "${TARGET}" = "vscodium" ]; then
		CLI="$(find_vscodium_cli)"
	else
		CLI="antigravity"
	fi
	shift
else
	if command -v antigravity > "/dev/null" 2>&1; then
		CLI="antigravity"
		TARGET="antigravity"
	elif [ -n "$(find_vscode_cli)" ]; then
		CLI="$(find_vscode_cli)"
		TARGET="vscode"
	elif [ -n "$(find_vscodium_cli)" ]; then
		CLI="$(find_vscodium_cli)"
		TARGET="vscodium"
	fi
fi

if [ -z "${CLI}" ] || ! command -v "${CLI}" > "/dev/null" 2>&1; then
	echo "❌ [IDE Extensions]: Nenhuma CLI de editor suportada encontrada (antigravity, code, vscode, codium)." >&2
	exit 1
fi

ACTION="${1:-install}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

find_local_extensions_file() {
	_target_app="$1"
	if [ -n "${PROFILE_DIR:-}" ] && [ -f "${PROFILE_DIR}/editors/${_target_app}/extensions.txt" ]; then
		echo "${PROFILE_DIR}/editors/${_target_app}/extensions.txt"
		return 0
	fi
	if [ -f "${SCRIPT_DIR}/../../../Profile/editors/${_target_app}/extensions.txt" ]; then
		echo "${SCRIPT_DIR}/../../../Profile/editors/${_target_app}/extensions.txt"
		return 0
	fi
	if [ -f "${HOME}/.local/share/profile/editors/${_target_app}/extensions.txt" ]; then
		echo "${HOME}/.local/share/profile/editors/${_target_app}/extensions.txt"
		return 0
	fi
	if [ -f "${HOME}/.config/profile/editors/${_target_app}/extensions.txt" ]; then
		echo "${HOME}/.config/profile/editors/${_target_app}/extensions.txt"
		return 0
	fi
	return 1
}

LOCAL_FILE="$(find_local_extensions_file "${TARGET}" 2> "/dev/null" || true)"
RAW_URL="https://raw.githubusercontent.com/GabrielFrigo4/profile/main/editors/${TARGET}/extensions.txt"

if [ "${ACTION}" = "export" ] || [ "${ACTION}" = "dump" ]; then
	[ -z "${LOCAL_FILE}" ] && LOCAL_FILE="${HOME}/.local/share/profile/editors/${TARGET}/extensions.txt"
	echo "📦 [IDE Extensions]: Exportando extensões instaladas via ${CLI} para ${LOCAL_FILE}..."
	mkdir -p "$(dirname "${LOCAL_FILE}")"
	"${CLI}" --list-extensions | sort > "${LOCAL_FILE}"
	echo "✅ [IDE Extensions]: Lista exportada com sucesso em ${LOCAL_FILE}!"
	exit 0
fi

TEMP_FILE=""
if [ -n "${LOCAL_FILE}" ] && [ -f "${LOCAL_FILE}" ]; then
	EXT_FILE="${LOCAL_FILE}"
else
	TEMP_FILE="$(mktemp)"
	echo "🌐 [IDE Extensions]: Buscando extensões declaradas para ${TARGET} no GitHub..."
	if ! curl -fsSL "${RAW_URL}" -o "${TEMP_FILE}"; then
		echo "❌ [IDE Extensions]: Erro ao baixar extensões de ${RAW_URL}" >&2
		rm -f "${TEMP_FILE}"
		exit 1
	fi
	EXT_FILE="${TEMP_FILE}"
fi

echo "📦 [IDE Extensions]: Sincronizando extensões declaradas no ${TARGET} (${CLI})..."

while IFS= read -r line || [ -n "${line}" ]; do
	line="$(echo "${line}" | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
	case "${line}" in
		\#*|"") continue ;;
	esac

	echo "  ➔ Instalando: ${line}"
	"${CLI}" --install-extension "${line}" --force || true
done < "${EXT_FILE}"

[ -n "${TEMP_FILE}" ] && rm -f "${TEMP_FILE}"

echo "✅ [IDE Extensions]: Extensões sincronizadas com sucesso no ${TARGET}!"
