#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: KDE Plasma Wayland Desktop
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando ambiente gráfico KDE Plasma..."

${ELEVATE} pkg install --yes sysutils/desktop-installer x11/wl-clipboard x11/xclip ports-mgmt/octopkg archivers/ark x11-themes/plasma6-breeze-gtk graphics/gimp3-app

_ui_ok "Ambiente pronto! Execute 'desktop-installer' para seleção interativa se necessário."
