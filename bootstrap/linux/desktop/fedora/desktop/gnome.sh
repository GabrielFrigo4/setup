#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: GNOME Desktop Settings & Keybindings
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Fedora GNOME]: Configurando ambiente GNOME e atalhos..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} dnf install --assumeyes gnome-tweak-tool adw-gtk3-theme plasma-breeze-qt6

mkdir -p "${HOME}/.config/environment.d"
echo "QT_QPA_PLATFORMTHEME=qt6ct" > "${HOME}/.config/environment.d/qt.conf"

command -v systemctl > "/dev/null" 2>&1 && systemctl --user set-environment QT_QPA_PLATFORMTHEME=qt6ct 2> "/dev/null" || true
command -v dbus-update-activation-environment > "/dev/null" 2>&1 && dbus-update-activation-environment --systemd QT_QPA_PLATFORMTHEME=qt6ct 2> "/dev/null" || true

gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark" 2> "/dev/null" || true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close" 2> "/dev/null" || true

gsettings set org.gnome.desktop.wm.keybindings show-desktop "[]" 2> "/dev/null" || true
gsettings set org.gnome.desktop.wm.keybindings minimize "[]" 2> "/dev/null" || true
gsettings set org.gnome.desktop.wm.keybindings maximize "[]" 2> "/dev/null" || true

gsettings set org.gnome.settings-daemon.plugins.media-keys calculator "['<Super>c']" 2> "/dev/null" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>s']" 2> "/dev/null" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>w']" 2> "/dev/null" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>h']" 2> "/dev/null" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>f']" 2> "/dev/null" || true

create_launcher() {
	KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${1}/"
	gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${KEY_PATH}" "name" "${2}"
	gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${KEY_PATH}" "command" "${3}"
	gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${KEY_PATH}" "binding" "${4}"

	CURRENT_LIST="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"
	case "${CURRENT_LIST}" in
		*"${KEY_PATH}"*) ;;
		"@as []"|"[]") gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['${KEY_PATH}']" ;;
		*) gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$(echo "${CURRENT_LIST}" | sed "s|]$|, '${KEY_PATH}']|")" ;;
	esac
}

create_launcher "0" "System Monitor" "gnome-system-monitor" "<Primary><Shift>Escape"
create_launcher "1" "Terminal" "kgx" "<Super>Return"
create_launcher "2" "File Manager" "nautilus" "<Super>e"
create_launcher "3" "Text Editor" "gnome-text-editor" "<Super>t"

echo "✅ [Fedora GNOME]: Ambiente configurado com sucesso!"
