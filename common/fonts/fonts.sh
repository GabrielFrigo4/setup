#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common System & Nerd Fonts
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

FONTS_DIR="${HOME}/.local/share/fonts"

if [ -f "${FONTS_DIR}/MesloLGS NF Regular.ttf" ] && ls "${FONTS_DIR}"/JetBrainsMono* > "/dev/null" 2>&1 && ls "${FONTS_DIR}"/RobotoMono* > "/dev/null" 2>&1; then
	_ui_ok "Nerd Fonts já instaladas em ${FONTS_DIR}."
	exit 0
fi

_ui_step "Instalando fontes Liberation e Nerd Fonts..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes x11-fonts/liberation-fonts-ttf
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes liberation-fonts
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes fonts-liberation
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman --sync --needed --noconfirm ttf-liberation
fi

mkdir -p "${FONTS_DIR}"

_TMP_DIR="$(mktemp -d)"

if ! ls "${FONTS_DIR}"/RobotoMono* > "/dev/null" 2>&1; then
	_ui_sub "Baixando RobotoMono Nerd Font..."
	curl -fsSL -o "${_TMP_DIR}/RobotoMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip"
	unzip -qo "${_TMP_DIR}/RobotoMono.zip" -d "${FONTS_DIR}"
	rm -f "${FONTS_DIR}/LICENSE.txt" "${FONTS_DIR}/README.md"
fi

if ! ls "${FONTS_DIR}"/JetBrainsMono* > "/dev/null" 2>&1; then
	_ui_sub "Baixando JetBrainsMono Nerd Font..."
	curl -fsSL -o "${_TMP_DIR}/JetBrainsMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
	unzip -qo "${_TMP_DIR}/JetBrainsMono.zip" -d "${FONTS_DIR}"
	rm -f "${FONTS_DIR}/OFL.txt" "${FONTS_DIR}/README.md"
fi

if [ ! -f "${FONTS_DIR}/MesloLGS NF Regular.ttf" ]; then
	_ui_sub "Baixando MesloLGS Nerd Fonts..."
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

_ui_ok "Fontes instaladas e cache atualizado com sucesso!"
