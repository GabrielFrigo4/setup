#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Blender 3D Creation Suite Provisioning
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v blender > "/dev/null" 2>&1 \
	|| { command -v flatpak > "/dev/null" 2>&1 && flatpak info org.blender.Blender > "/dev/null" 2>&1; } \
	|| { command -v winget.exe > "/dev/null" 2>&1 && winget.exe list --id BlenderFoundation.Blender > "/dev/null" 2>&1; }; then
	_ui_ok "Blender 3D Suite já está instalado."
	exit 0
fi

_ui_step "Provisionando suite de criação 3D Blender..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes graphics/blender
	_ui_ok "Blender instalado com sucesso via FreeBSD pkg!"
elif command -v dnf > "/dev/null" 2>&1; then
	if ${ELEVATE} dnf install --assumeyes blender 2> "/dev/null"; then
		_ui_ok "Blender instalado com sucesso via DNF!"
	else
		_ui_warn "Falha ao instalar pacote nativo via DNF; tentando Flatpak..."
		if ! command -v flatpak > "/dev/null" 2>&1; then
			${ELEVATE} dnf install --assumeyes flatpak
		fi
		flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo" 2> "/dev/null" || true
		flatpak install --assumeyes flathub org.blender.Blender
		_ui_ok "Blender instalado via Flatpak no Fedora/RHEL!"
	fi
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	if ${ELEVATE} apt-get install --yes blender 2> "/dev/null"; then
		_ui_ok "Blender instalado com sucesso via APT!"
	else
		_ui_warn "Falha ao instalar pacote nativo via APT; tentando Flatpak..."
		if ! command -v flatpak > "/dev/null" 2>&1; then
			${ELEVATE} apt-get install --yes flatpak
		fi
		flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo" 2> "/dev/null" || true
		flatpak install --assumeyes flathub org.blender.Blender
		_ui_ok "Blender instalado via Flatpak no Debian/Ubuntu!"
	fi
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		if command -v winget.exe > "/dev/null" 2>&1; then
			winget.exe install --id BlenderFoundation.Blender --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
			_ui_ok "Blender instalado via Winget no ambiente MSYS2!"
		else
			_ui_warn "Winget não encontrado para provisionar Blender no MSYS2."
		fi
	elif command -v yay > "/dev/null" 2>&1; then
		yay -S --needed --noconfirm blender
		_ui_ok "Blender instalado com sucesso via AUR (yay)!"
	elif command -v paru > "/dev/null" 2>&1; then
		paru -S --needed --noconfirm blender
		_ui_ok "Blender instalado com sucesso via AUR (paru)!"
	else
		${ELEVATE} pacman -S --needed --noconfirm blender
		_ui_ok "Blender instalado com sucesso via pacman!"
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id BlenderFoundation.Blender --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	_ui_ok "Blender instalado com sucesso via Winget!"
elif command -v flatpak > "/dev/null" 2>&1; then
	flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo" 2> "/dev/null" || true
	flatpak install --assumeyes flathub org.blender.Blender
	_ui_ok "Blender instalado com sucesso via Flatpak!"
else
	_ui_err "Gerenciador de pacotes compatível não encontrado."
	exit 1
fi

_ui_ok "Blender 3D Suite provisionado com sucesso!"
