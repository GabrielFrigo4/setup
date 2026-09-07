#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Desktop Applications & GUI Tools
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Arch Apps]: Instalando aplicativos desktop e ferramentas gráficas..."

yay --needed --noconfirm -S \
	kde-applications \
	kde-utilities \
	gnome-screenshot \
	libreoffice-still \
	onlyoffice-desktopeditors \
	microsoft-edge-stable \
	google-chrome \
	discord \
	zoom \
	handbrake \
	obs-studio \
	feh \
	scilab \
	gimp \
	krita \
	inkscape \
	libresprite \
	blender \
	freecad \
	galaxybudsclient-bin \
	etcher-bin \
	texworks \
	vmware-keymaps \
	vmware-workstation \
	remmina \
	freerdp \
	steam

echo "✅ [Arch Apps]: Aplicativos desktop instalados com sucesso!"
