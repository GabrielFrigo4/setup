#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Tool: Line Endings Converter (LF <-> CRLF)
# ------------------------------------------------------------------------------
set -eu

MODE="${1:---to-unix}"
TARGET_DIR="${2:-.}"
CR="$(printf '\r')"

case "${MODE}" in
	--to-unix|-u)
		echo "📦 [Line Endings]: Convertendo finais de linha para LF (UNIX)..."
		find "${TARGET_DIR}" -type f \( -name "*.sh" -o -name "*.ps1" -o -name "*.lua" -o -name "*.cmd" -o -name "*.md" -o -name "*.nu" -o -name "*.json" -o -name "*.toml" -o -name "*.yaml" \) | while read -r FILE_PATH; do
			if grep -q "${CR}" "$FILE_PATH" 2> "/dev/null"; then
				TEMP_FILE="$(mktemp)"
				tr -d '\r' < "$FILE_PATH" > "$TEMP_FILE"
				mv "$TEMP_FILE" "$FILE_PATH"
				printf "  \033[32m➔ LF: %s\033[0m\n" "${FILE_PATH}"
			fi
		done
		;;
	--to-dos|-d)
		echo "📦 [Line Endings]: Convertendo finais de linha para CRLF (Windows/DOS)..."
		find "${TARGET_DIR}" -type f \( -name "*.cmd" -o -name "*.reg" \) | while read -r FILE_PATH; do
			if ! grep -q "${CR}" "$FILE_PATH" 2> "/dev/null"; then
				TEMP_FILE="$(mktemp)"
				sed 's/$/\r/' "$FILE_PATH" > "$TEMP_FILE"
				mv "$TEMP_FILE" "$FILE_PATH"
				printf "  \033[32m➔ CRLF: %s\033[0m\n" "${FILE_PATH}"
			fi
		done
		;;
	*)
		echo "Uso: $0 [--to-unix | --to-dos] [diretório]" >&2
		exit 1
		;;
esac

echo "✅ [Line Endings]: Conversão concluída com sucesso!"
