#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: LibreOffice Productivity Suite & Desktop Dark Theme
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Provisionando suite LibreOffice e integração desktop..."

### --------------------------------
### 1. INSTALACAO DO PACOTE
### --------------------------------
if command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw libreoffice-math libreoffice-base libreoffice-gtk3 libreoffice-gtk4
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq
	${ELEVATE} apt-get install --yes libreoffice libreoffice-gtk3 libreoffice-gtk4
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm libreoffice-fresh
elif command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes editors/libreoffice
fi

### --------------------------------
### 2. FLATPAK DARK OVERRIDE
### --------------------------------
if command -v flatpak > "/dev/null" 2>&1; then
	flatpak override --user --env=GTK_THEME=Adwaita:dark 2> "/dev/null" || true
	if [ -n "${ELEVATE:-}" ] || [ "$(id -u)" -eq 0 ]; then
		${ELEVATE} flatpak override --env=GTK_THEME=Adwaita:dark 2> "/dev/null" || true
	fi
fi

### --------------------------------
### 3. ENVIRONMENT.D CONFIG
### --------------------------------
mkdir -p "${HOME}/.config/environment.d"
cat <<- "EOF" > "${HOME}/.config/environment.d/gtk-dark.conf"
GTK_THEME=adw-gtk3-dark
GTK_APPLICATION_PREFER_DARK_THEME=1
SAL_USE_VCLPLUGIN=gtk3
EOF

command -v systemctl > "/dev/null" 2>&1 && systemctl --user set-environment GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 SAL_USE_VCLPLUGIN=gtk3 2> "/dev/null" || true
command -v dbus-update-activation-environment > "/dev/null" 2>&1 && dbus-update-activation-environment --systemd GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 SAL_USE_VCLPLUGIN=gtk3 2> "/dev/null" || true

### --------------------------------
### 4. INTEGRACAO DESKTOP DARK
### --------------------------------
_apps_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/applications"
mkdir -p "${_apps_dir}"

_theme="adw-gtk3-dark"
if [ ! -d "/usr/share/themes/adw-gtk3-dark" ] && [ ! -d "${HOME}/.themes/adw-gtk3-dark" ] && [ ! -d "/usr/local/share/themes/adw-gtk3-dark" ]; then
	_theme="Adwaita:dark"
fi

_prefix="env SAL_USE_VCLPLUGIN=gtk3 GTK_THEME=${_theme} GTK_APPLICATION_PREFER_DARK_THEME=1 "

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

_ui_ok "LibreOffice configurado com tema escuro GTK3 com sucesso!"
