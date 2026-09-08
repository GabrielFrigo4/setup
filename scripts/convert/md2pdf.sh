#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Markdown to PDF Batch Converter (POSIX)
# ----------------------------------------------------------------
set -eu

if [ -z "${1-}" ] || [ ! -d "${1}" ]; then
	printf "\033[31mErro: Forneça um diretório válido.\033[0m\n"
	exit 1
fi

INPUT_DIR="$(cd "${1}" && pwd)"
BASE_NAME="$(basename "$INPUT_DIR")"
OUTPUT_ROOT="$(dirname "$INPUT_DIR")/${BASE_NAME}.pdf"

echo "📦 [Markdown PDF]: Iniciando conversão de Markdown para PDF..."

mkdir -p "$OUTPUT_ROOT"

find "$INPUT_DIR" -type f -name "*.md" -not -path "$OUTPUT_ROOT/*" | while read -r MD_FILE; do
	RELATIVE_DIR="$(dirname "${MD_FILE#"${INPUT_DIR}/"}")"
	TARGET_DIR="$OUTPUT_ROOT/$RELATIVE_DIR"

	mkdir -p "$TARGET_DIR"

	FILE_BASE="$(basename "$MD_FILE" .md)"
	PDF_OUTPUT="$TARGET_DIR/$FILE_BASE.pdf"

	printf "\033[36mPDF: %s.pdf\033[0m\n" "$FILE_BASE"

	pandoc "$MD_FILE" -o "$PDF_OUTPUT" \
		--pdf-engine=weasyprint \
		-V margin-top=20mm -V margin-bottom=20mm \
		-V margin-left=15mm -V margin-right=15mm
done

echo "✅ [Markdown PDF]: Documentos PDF gerados com sucesso em ${OUTPUT_ROOT}!"
