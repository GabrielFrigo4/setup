#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Linux Universal Flatpak & Flathub Integration
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Linux Flatpak]: Instalando Flatpak e configurando Flathub..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes flatpak
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes flatpak gnome-software-plugin-flatpak
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm flatpak
fi

flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"

echo "✅ [Linux Flatpak]: Flatpak e Flathub configurados com sucesso!"
