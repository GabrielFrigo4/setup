#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Collabora Office Cross-Platform Desktop Provisioning
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v collaboraoffice > "/dev/null" 2>&1 || { command -v flatpak > "/dev/null" 2>&1 && flatpak info com.collaboraoffice.Office > "/dev/null" 2>&1; }; then
	_ui_ok "Collabora Office já está instalado."
	exit 0
fi

_ui_step "Provisionando suite de produtividade desktop Collabora Office..."

### --------------------------------
### Package Manager Dispatch
### --------------------------------
if command -v pkg > "/dev/null" 2>&1; then
	if pkg search -q "^collabora-office$" > "/dev/null" 2>&1 || pkg search -q "^collabora$" > "/dev/null" 2>&1; then
		${ELEVATE} pkg install --yes editors/collabora-office
		_ui_ok "Pacote nativo FreeBSD instalado com sucesso!"
	else
		_ui_info "Pacote nativo 'collabora-office' ainda não disponibilizado no repositório pkg do FreeBSD."
		_ui_sub "Instalação ocorrerá automaticamente assim que o port for publicado upstream."
	fi
elif command -v dnf > "/dev/null" 2>&1; then
	if ! command -v flatpak > "/dev/null" 2>&1; then
		${ELEVATE} dnf install --assumeyes flatpak
	fi
	flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
	flatpak install --assumeyes flathub com.collaboraoffice.Office
	_ui_ok "Collabora Office instalado via Flatpak/Flathub!"
elif command -v apt-get > "/dev/null" 2>&1; then
	if ! command -v flatpak > "/dev/null" 2>&1; then
		${ELEVATE} apt-get update -qq
		${ELEVATE} apt-get install --yes flatpak
	fi
	flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
	flatpak install --assumeyes flathub com.collaboraoffice.Office
	_ui_ok "Collabora Office instalado via Flatpak/Flathub!"
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		if command -v winget.exe > "/dev/null" 2>&1; then
			winget.exe install 9P9MRBXJJG0M --accept-package-agreements --accept-source-agreements
			_ui_ok "Collabora Office instalado via Winget no ambiente MSYS2!"
		fi
	elif command -v yay > "/dev/null" 2>&1; then
		yay -S --needed --noconfirm collabora-office-bin
		_ui_ok "Collabora Office instalado via AUR (yay)!"
	elif command -v paru > "/dev/null" 2>&1; then
		paru -S --needed --noconfirm collabora-office-bin
		_ui_ok "Collabora Office instalado via AUR (paru)!"
	else
		if ! command -v flatpak > "/dev/null" 2>&1; then
			${ELEVATE} pacman -S --needed --noconfirm flatpak
		fi
		flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
		flatpak install --assumeyes flathub com.collaboraoffice.Office
		_ui_ok "Collabora Office instalado via Flatpak/Flathub!"
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install 9P9MRBXJJG0M --accept-package-agreements --accept-source-agreements
	_ui_ok "Collabora Office instalado via Winget!"
elif command -v flatpak > "/dev/null" 2>&1; then
	flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
	flatpak install --assumeyes flathub com.collaboraoffice.Office
	_ui_ok "Collabora Office instalado via Flatpak/Flathub!"
else
	_ui_err "Gerenciador de pacotes compatível não encontrado."
	exit 1
fi
