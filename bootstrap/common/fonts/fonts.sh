#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Common System & Nerd Fonts
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Common Fonts]: Instalando fontes Nerd Fonts e de programação..."

FONTS_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONTS_DIR}"

_TMP_DIR="$(mktemp -d)"

if ! ls "${FONTS_DIR}"/RobotoMono* > "/dev/null" 2>&1; then
	echo "  ➔ Baixando RobotoMono Nerd Font..."
	curl -fsSL -o "${_TMP_DIR}/RobotoMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip"
	unzip -qo "${_TMP_DIR}/RobotoMono.zip" -d "${FONTS_DIR}"
	rm -f "${FONTS_DIR}/LICENSE.txt" "${FONTS_DIR}/README.md"
fi

if ! ls "${FONTS_DIR}"/JetBrainsMono* > "/dev/null" 2>&1; then
	echo "  ➔ Baixando JetBrainsMono Nerd Font..."
	curl -fsSL -o "${_TMP_DIR}/JetBrainsMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
	unzip -qo "${_TMP_DIR}/JetBrainsMono.zip" -d "${FONTS_DIR}"
	rm -f "${FONTS_DIR}/OFL.txt" "${FONTS_DIR}/README.md"
fi

if [ ! -f "${FONTS_DIR}/MesloLGS NF Regular.ttf" ]; then
	echo "  ➔ Baixando MesloLGS Nerd Fonts..."
	for _style in "Regular" "Bold" "Italic" "Bold%20Italic"; do
		case "${_style}" in
			"Bold%20Italic") _name="MesloLGS NF Bold Italic.ttf" ;;
			*) _name="MesloLGS NF ${_style}.ttf" ;;
		esac
		curl -fsSL -o "${FONTS_DIR}/${_name}" \
			"https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${_style}.ttf" || true
	done
fi

rm -rf "${_TMP_DIR}"

if command -v fc-cache > "/dev/null" 2>&1; then
	fc-cache -f "${FONTS_DIR}" 2> "/dev/null" || true
fi

echo "✅ [Common Fonts]: Fontes instaladas e cache atualizado com sucesso!"
