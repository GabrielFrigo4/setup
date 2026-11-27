#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: KDE Plasma Wayland Desktop
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando ambiente gráfico KDE Plasma..."

${ELEVATE} pkg install -y \
	x11/kde \
	x11/konsole \
	sysutils/seatd \
	devel/dbus \
	x11/wl-clipboard \
	ports-mgmt/octopkg \
	archivers/ark \
	x11-themes/plasma6-breeze-gtk \
	graphics/gimp3-app \
	x11-themes/adwaita-icon-theme \
	x11-themes/kf6-breeze-icons \
	x11/xsettingsd \
	multimedia/pipewire \
	multimedia/wireplumber \
	deskutils/xdg-desktop-portal \
	x11/plasma6-xdg-desktop-portal-kde \
	multimedia/plasma6-kpipewire

[ "$(sysrc -n dbus_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc dbus_enable="YES" > "/dev/null" 2>&1 || true
[ "$(sysrc -n seatd_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc seatd_enable="YES" > "/dev/null" 2>&1 || true

pkg info -e gimp > "/dev/null" 2>&1 && pkg info -e gimp3-app > "/dev/null" 2>&1 && ${ELEVATE} pkg delete --yes gimp > "/dev/null" 2>&1 || true
[ -d "/usr/local/etc/pulse" ] && { ${ELEVATE} mkdir -p "/usr/local/etc/pulse/default.pa.d"; ${ELEVATE} chmod 0755 "/usr/local/etc/pulse/default.pa.d"; } || true

### --------------------------------
### DESATIVACAO DO BALOO INDEXER
### --------------------------------
_ui_sub "Desativando indexador de arquivos Baloo e DiscoverNotifier..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
TARGET_HOME="$(getent passwd "${TARGET_USER}" 2> "/dev/null" | cut -d: -f6 || echo "${HOME}")"

if [ -n "${TARGET_HOME}" ] && [ -d "${TARGET_HOME}" ]; then
	mkdir -p "${TARGET_HOME}/.config/autostart"
	cat <<- "EOF" > "${TARGET_HOME}/.config/autostart/org.kde.discover.notifier.desktop"
		[Desktop Entry]
		Hidden=true
	EOF
	chown "${TARGET_USER}" "${TARGET_HOME}/.config/autostart/org.kde.discover.notifier.desktop" 2> "/dev/null" || true
	chmod 0644 "${TARGET_HOME}/.config/autostart/org.kde.discover.notifier.desktop" 2> "/dev/null" || true
	_baloo_cfg="${TARGET_HOME}/.config/baloofilerc"
	[ -d "${TARGET_HOME}/.config" ] || mkdir -p "${TARGET_HOME}/.config"
	if [ -f "${_baloo_cfg}" ]; then
		if grep -q "^\[Basic Settings\]" "${_baloo_cfg}" 2> "/dev/null"; then
			_tmp="$(mktemp "/tmp/baloofilerc.XXXXXX")"
			if grep -q "^Indexing-Enabled=" "${_baloo_cfg}" 2> "/dev/null"; then
				sed 's|^Indexing-Enabled=.*|Indexing-Enabled=false|' "${_baloo_cfg}" > "${_tmp}"
			else
				sed '/^\[Basic Settings\]/a\
Indexing-Enabled=false' "${_baloo_cfg}" > "${_tmp}"
			fi
			cp "${_tmp}" "${_baloo_cfg}"
			rm -f "${_tmp}"
		else
			cat <<- "EOF" >> "${_baloo_cfg}"
			[Basic Settings]
			Indexing-Enabled=false
			EOF
		fi
	else
		cat <<- "EOF" > "${_baloo_cfg}"
		[Basic Settings]
		Indexing-Enabled=false
		EOF
	fi
	chown "${TARGET_USER}" "${_baloo_cfg}" 2> "/dev/null" || true
	chmod 0644 "${_baloo_cfg}" 2> "/dev/null" || true
fi

if command -v balooctl6 > "/dev/null" 2>&1; then
	balooctl6 disable > "/dev/null" 2>&1 || true
	balooctl6 purge > "/dev/null" 2>&1 || true
fi

### --------------------------------
### OTIMIZACAO CACHE MAPEADO KDE
### --------------------------------
_ui_sub "Configurando KDEVARTMP para contornar fallocate no ZFS..."

_plasma_env_dir="/usr/local/etc/xdg/plasma-workspace/env"
[ -d "${_plasma_env_dir}" ] || ${ELEVATE} mkdir -p "${_plasma_env_dir}"

cat <<- "EOF" | ${ELEVATE} tee "${_plasma_env_dir}/kdevartmp.sh" > "/dev/null"
#!/usr/bin/env sh
export KDEVARTMP="/tmp"
EOF
${ELEVATE} chmod 0755 "${_plasma_env_dir}/kdevartmp.sh"

### --------------------------------
### AMBIENTE E PATH DA SESSAO KDE
### --------------------------------
_ui_sub "Configurando PATH de sessao para ~/.local/bin..."

cat <<- "EOF" | ${ELEVATE} tee "${_plasma_env_dir}/path.sh" > "/dev/null"
#!/usr/bin/env sh
case ":${PATH}:" in
	*":${HOME}/.local/bin:"*) ;;
	*) export PATH="${HOME}/.local/bin:${PATH}" ;;
esac
EOF
${ELEVATE} chmod 0755 "${_plasma_env_dir}/path.sh"

_ui_ok "Ambiente KDE Plasma Wayland configurado com sucesso!"
