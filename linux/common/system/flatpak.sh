#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal Flatpak & Flathub Integration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Flatpak e configurando Flathub..."

if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes flatpak
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes flatpak gnome-software-plugin-flatpak
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm flatpak
fi

flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"

_ui_ok "Flatpak e Flathub configurados com sucesso!"
