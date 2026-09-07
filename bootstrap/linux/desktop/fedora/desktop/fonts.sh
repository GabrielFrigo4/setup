#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: System Fonts (Carlito & Caladea)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Fedora Fonts]: Instalando fontes Carlito e Caladea..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} dnf install --assumeyes google-carlito-fonts google-caladea-fonts

FONTCONFIG_DIR="${HOME}/.config/fontconfig"
mkdir -p "${FONTCONFIG_DIR}"

cat << 'EOF' > "${FONTCONFIG_DIR}/fonts.conf"
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias binding="same">
    <family>Calibri</family>
    <accept>
      <family>Carlito</family>
    </accept>
  </alias>
  <alias binding="same">
    <family>Cambria</family>
    <accept>
      <family>Caladea</family>
    </accept>
  </alias>
</fontconfig>
EOF

if command -v fc-cache > "/dev/null" 2>&1; then
	fc-cache -f "${HOME}/.local/share/fonts" 2> "/dev/null" || true
fi

echo "✅ [Fedora Fonts]: Fontes instaladas e mapeadas em fonts.conf!"
