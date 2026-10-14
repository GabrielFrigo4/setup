#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Google Antigravity IDE & CLI
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Antigravity IDE & CLI..."

if ! command -v antigravity > "/dev/null" 2>&1; then
	curl -fsSL https://antigravity.google/cli/install.sh | sh
fi

if [ -f "/opt/antigravity/bin/antigravity-ide" ]; then
	${ELEVATE} ln -sf "/opt/antigravity/bin/antigravity-ide" "/usr/local/bin/antigravity"
	${ELEVATE} ln -sf "/opt/antigravity/bin/antigravity-ide" "/usr/local/bin/antigravity-ide"
elif [ -f "/opt/antigravity/antigravity-ide" ]; then
	${ELEVATE} ln -sf "/opt/antigravity/antigravity-ide" "/usr/local/bin/antigravity"
	${ELEVATE} ln -sf "/opt/antigravity/antigravity-ide" "/usr/local/bin/antigravity-ide"
fi

if [ -f "/opt/antigravity/antigravity-ide" ]; then
	cat <<- "EOF" | ${ELEVATE} tee "/usr/share/applications/antigravity.desktop" > "/dev/null"
	[Desktop Entry]
	Name=Antigravity IDE
	Comment=Antigravity IDE
	Exec=/opt/antigravity/antigravity-ide %U
	Terminal=false
	Type=Application
	Icon=/opt/antigravity/resources/app/resources/linux/code.png
	Categories=Development;IDE;
	StartupWMClass=antigravity-ide
	MimeType=x-scheme-handler/antigravity;
	EOF
fi

_ui_ok "Antigravity IDE & CLI configurados com sucesso!"
