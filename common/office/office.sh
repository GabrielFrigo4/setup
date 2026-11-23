#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: LibreOffice Productivity Suite & Adaptive GTK3 Theme
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Provisionando suite LibreOffice e integração desktop..."

_install_libreoffice_win() {
	if command -v soffice.exe > "/dev/null" 2>&1 || [ -f "/c/Program Files/LibreOffice/program/soffice.exe" ] || [ -f "/c/Program Files (x86)/LibreOffice/program/soffice.exe" ]; then
		_ui_ok "LibreOffice já está instalado no Windows."
		exit 0
	fi
	if command -v winget.exe > "/dev/null" 2>&1; then
		winget.exe install --id TheDocumentFoundation.LibreOffice --accept-package-agreements --accept-source-agreements
		_ui_ok "LibreOffice instalado via Winget!"
		exit 0
	fi
	_ui_err "Winget não encontrado para instalar o LibreOffice no Windows."
	exit 1
}

### --------------------------------
### 1. INSTALACAO DO PACOTE
### --------------------------------
if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes editors/libreoffice textproc/hunspell textproc/en-hunspell portuguese/hunspell
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw libreoffice-math libreoffice-base libreoffice-gtk3 libreoffice-gtk4 hunspell hunspell-en hunspell-pt
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq
	${ELEVATE} apt-get install --yes libreoffice libreoffice-gtk3 libreoffice-gtk4 hunspell hunspell-en-us hunspell-pt-br
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		_install_libreoffice_win
	else
		${ELEVATE} pacman -S --needed --noconfirm libreoffice-fresh hunspell hunspell-en_us hunspell-pt-br
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	_install_libreoffice_win
fi

### --------------------------------
### 2. FLATPAK GTK3 THEME
### --------------------------------
if command -v flatpak > "/dev/null" 2>&1; then
	flatpak override --user --unset-env=GTK_THEME 2> "/dev/null" || true
	if [ -n "${ELEVATE:-}" ] || [ "$(id -u)" -eq 0 ]; then
		${ELEVATE} flatpak override --unset-env=GTK_THEME 2> "/dev/null" || true
	fi
	if flatpak remotes --columns=name 2> "/dev/null" | grep -qx "flathub"; then
		if flatpak remotes --system --columns=name 2> "/dev/null" | grep -qx "flathub"; then
			${ELEVATE} flatpak install --system --assumeyes --noninteractive --or-update flathub \
				org.gtk.Gtk3theme.adw-gtk3 \
				org.gtk.Gtk3theme.adw-gtk3-dark 2> "/dev/null" || \
				flatpak install --system --assumeyes --noninteractive --or-update flathub \
				org.gtk.Gtk3theme.adw-gtk3 \
				org.gtk.Gtk3theme.adw-gtk3-dark 2> "/dev/null" || true
		else
			flatpak install --user --assumeyes --noninteractive --or-update flathub \
				org.gtk.Gtk3theme.adw-gtk3 \
				org.gtk.Gtk3theme.adw-gtk3-dark 2> "/dev/null" || true
		fi
	fi
fi

### --------------------------------
### 3. ENVIRONMENT CLEANUP
### --------------------------------
rm -f "${HOME}/.config/environment.d/gtk-dark.conf"

if command -v systemctl > "/dev/null" 2>&1; then
	systemctl --user unset-environment GTK_THEME GTK_APPLICATION_PREFER_DARK_THEME 2> "/dev/null" || true
	systemctl --user set-environment SAL_USE_VCLPLUGIN=gtk3 2> "/dev/null" || true
fi
command -v dbus-update-activation-environment > "/dev/null" 2>&1 && \
	dbus-update-activation-environment --systemd SAL_USE_VCLPLUGIN=gtk3 2> "/dev/null" || true

### --------------------------------
### 4. INTEGRACAO DESKTOP GTK3
### --------------------------------
_apps_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/applications"
mkdir -p "${_apps_dir}"

_prefix="env SAL_USE_VCLPLUGIN=gtk3 "

for _src_dir in "/usr/share/applications" "/usr/local/share/applications"; do
	if [ -d "${_src_dir}" ]; then
		for _desktop in "${_src_dir}"/libreoffice*.desktop; do
			if [ -f "${_desktop}" ]; then
				_base="$(basename "${_desktop}")"
				_target="${_apps_dir}/${_base}"
				cp -f "${_desktop}" "${_target}"
				chmod 0644 "${_target}"
				sed -i '' -e "s|^Exec=libreoffice|Exec=${_prefix}libreoffice|g" -e 's/^NoDisplay=true/NoDisplay=false/' "${_target}" 2> "/dev/null" || \
					sed -i -e "s|^Exec=libreoffice|Exec=${_prefix}libreoffice|g" -e 's/^NoDisplay=true/NoDisplay=false/' "${_target}" 2> "/dev/null" || true
			fi
		done
	fi
done

if command -v update-desktop-database > "/dev/null" 2>&1; then
	update-desktop-database "${_apps_dir}" 2> "/dev/null" || true
fi

_ui_ok "LibreOffice configurado com integração GTK3 adaptativa com sucesso!"
