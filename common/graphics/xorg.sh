#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: X11 Server, Tools & Micro-Window Managers Suite
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_is_bsd=0
[ "$(uname -s)" = "FreeBSD" ] && _is_bsd=1

_install_resilient() {
	_mgr="$1"
	[ "$#" -ge 1 ] && shift
	case "${_mgr}" in
		pkg)
			if ! ${ELEVATE} pkg install -y "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					${ELEVATE} pkg install -y "${_pkg}" 2> "/dev/null" || true
				done
			fi
			;;
		dnf)
			if ! ${ELEVATE} dnf install --assumeyes --skip-unavailable "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					${ELEVATE} dnf install --assumeyes "${_pkg}" 2> "/dev/null" || true
				done
			fi
			;;
		apt-get)
			${ELEVATE} apt-get update -qq 2> "/dev/null" || true
			if ! ${ELEVATE} apt-get install --yes "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					${ELEVATE} apt-get install --yes "${_pkg}" 2> "/dev/null" || true
				done
			fi
			;;
		pacman)
			if ! ${ELEVATE} pacman -S --needed --noconfirm "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					${ELEVATE} pacman -S --needed --noconfirm "${_pkg}" 2> "/dev/null" || true
				done
			fi
			;;
		yay)
			if ! yay -S --needed --noconfirm "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					yay -S --needed --noconfirm "${_pkg}" 2> "/dev/null" || true
				done
			fi
			;;
		pkg_add)
			if ! ${ELEVATE} pkg_add -I "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					${ELEVATE} pkg_add -I "${_pkg}" 2> "/dev/null" || true
				done
			fi
			;;
	esac
}

_ui_step "Provisionando ecossistema gráfico X11, compositores e gerenciadores..."

### --------------------------------
### 1. INSTALACAO DE PACOTES
### --------------------------------
if command -v pkg > "/dev/null" 2>&1; then
	_install_resilient pkg \
		x11/xorg-minimal x11/xinit x11/xterm x11/xrdb x11/xdotool x11/wmctrl-fork \
		x11-toolkits/py-python-xlib x11-wm/openbox x11-wm/cwm x11-wm/dwm x11-wm/fvwm3 \
		x11-wm/fluxbox x11-wm/icewm x11-wm/jwm x11-wm/pekwm x11-wm/twm \
		x11-wm/picom x11-wm/xcompmgr x11/xsettingsd x11/rofi x11/dmenu \
		security/gnome-keyring security/libsecret \
		x11-themes/adwaita-icon-theme x11-themes/kf6-breeze-icons
	if ! command -v wmctrl > "/dev/null" 2>&1; then
		_install_resilient pkg x11/wmctrl
	fi
	if ! command -v fvwm3 > "/dev/null" 2>&1 && ! command -v fvwm > "/dev/null" 2>&1; then
		_install_resilient pkg x11-wm/fvwm
	fi
elif command -v dnf > "/dev/null" 2>&1; then
	_fedora_pkgs="xorg-x11-server-Xorg xorg-x11-xinit xterm xrdb xdotool wmctrl \
		python3-xlib openbox cwm fvwm3 fluxbox icewm jwm pekwm \
		matchbox-window-manager picom xcompmgr xsettingsd rofi dmenu \
		gnome-keyring libsecret adwaita-icon-theme adwaita-icon-theme-legacy \
		breeze-icon-theme xorg-x11-drv-intel xorg-x11-drv-amdgpu \
		xorg-x11-drv-ati xorg-x11-drv-nouveau"
	_missing=""
	for _pkg in ${_fedora_pkgs}; do
		rpm -q "${_pkg}" > "/dev/null" 2>&1 || _missing="${_missing} ${_pkg}"
	done
	if [ -n "${_missing}" ]; then
		_install_resilient dnf ${_missing} dwm twm
		if ! command -v fvwm3 > "/dev/null" 2>&1 && ! command -v fvwm > "/dev/null" 2>&1; then
			_install_resilient dnf fvwm
		fi
	fi
elif command -v apt-get > "/dev/null" 2>&1; then
	_install_resilient apt-get \
		xserver-xorg xinit xterm x11-xserver-utils xdotool wmctrl python3-xlib \
		openbox cwm dwm fvwm3 fluxbox icewm jwm pekwm twm \
		matchbox-window-manager picom xcompmgr xsettingsd rofi suckless-tools \
		gnome-keyring libsecret-1-0 libsecret-tools \
		adwaita-icon-theme breeze-icon-theme
	if ! command -v fvwm3 > "/dev/null" 2>&1 && ! command -v fvwm > "/dev/null" 2>&1; then
		_install_resilient apt-get fvwm
	fi
elif command -v pacman > "/dev/null" 2>&1; then
	_install_resilient pacman \
		xorg-server xorg-xinit xterm xorg-xrdb xdotool wmctrl python-xlib \
		openbox fvwm3 fluxbox icewm jwm pekwm xorg-twm picom xcompmgr \
		xsettingsd rofi dmenu gnome-keyring libsecret \
		adwaita-icon-theme breeze-icons
	if ! command -v fvwm3 > "/dev/null" 2>&1 && ! command -v fvwm > "/dev/null" 2>&1; then
		_install_resilient pacman fvwm
	fi
	if command -v yay > "/dev/null" 2>&1; then
		_install_resilient yay cwm dwm matchbox-window-manager
	fi
elif command -v pkg_add > "/dev/null" 2>&1; then
	_install_resilient pkg_add \
		xdotool wmctrl openbox cwm dwm fvwm3 fluxbox icewm jwm pekwm \
		picom xcompmgr xsettingsd rofi dmenu gnome-keyring libsecret \
		adwaita-icon-theme breeze-icons
	if ! command -v fvwm3 > "/dev/null" 2>&1 && ! command -v fvwm > "/dev/null" 2>&1; then
		_install_resilient pkg_add fvwm
	fi
else
	_ui_err "Gerenciador de pacotes não suportado para instalação do ecossistema X11."
	exit 1
fi

### --------------------------------
### 2. CONFIGURACAO DO XWRAPPER
### --------------------------------
if [ -d "/etc/X11" ]; then
	cat <<- EOF | ${ELEVATE} tee /etc/X11/Xwrapper.config > "/dev/null" 2>&1 || true
	allowed_users = anybody
	needs_root_rights = auto
	EOF
	${ELEVATE} chmod 0644 /etc/X11/Xwrapper.config 2> "/dev/null" || true
fi

### --------------------------------
### 3. CONFIGURACAO DO TEARFREE
### --------------------------------
_tearfree_conf='Section "OutputClass"
	Identifier "Modesetting TearFree"
	MatchDriver "i915|xe|i915kms|nouveau|virtio_gpu|vmwgfx|vboxvideo"
	Driver "modesetting"
	Option "AccelMethod" "glamor"
	Option "PageFlip" "on"
	Option "SWcursor" "off"
	Option "AsyncFlipSecondaries" "false"
EndSection

Section "OutputClass"
	Identifier "Intel Graphics"
	MatchDriver "i915|i915kms"
	Option "TearFree" "true"
EndSection

Section "OutputClass"
	Identifier "AMD Graphics"
	MatchDriver "amdgpu"
	Option "TearFree" "true"
	Option "PageFlip" "on"
EndSection

Section "OutputClass"
	Identifier "Radeon Graphics"
	MatchDriver "radeon|radeonkms"
	Option "TearFree" "true"
	Option "PageFlip" "on"
EndSection'

if [ -d "/etc/X11" ] || [ "${_is_bsd}" -eq 1 ]; then
	${ELEVATE} rm -f "/etc/X11/xorg.conf.d/20-swcursor.conf" "/usr/local/etc/X11/xorg.conf.d/20-swcursor.conf" 2> "/dev/null" || true
	for _xorg_conf_dir in "/etc/X11/xorg.conf.d" "/usr/local/etc/X11/xorg.conf.d"; do
		[ "${_is_bsd}" -eq 0 ] && [ "${_xorg_conf_dir}" = "/usr/local/etc/X11/xorg.conf.d" ] && continue
		${ELEVATE} mkdir -p "${_xorg_conf_dir}" 2> "/dev/null" || true
		printf '%s\n' "${_tearfree_conf}" | ${ELEVATE} tee "${_xorg_conf_dir}/20-tearfree.conf" > "/dev/null" 2>&1 || true
		${ELEVATE} chmod 0644 "${_xorg_conf_dir}/20-tearfree.conf" 2> "/dev/null" || true
	done
fi

### --------------------------------
### 4. AUTO-UNLOCK GNOME KEYRING
### --------------------------------
if [ "${_is_bsd}" -eq 1 ]; then
	if [ -f "/etc/pam.d/login" ] && grep -q "pam_gnome_keyring\.so" "/etc/pam.d/login" 2> "/dev/null"; then
		${ELEVATE} sed -i '' '/pam_gnome_keyring\.so/d' "/etc/pam.d/login" 2> "/dev/null" || true
	fi
else
	_pam_keyring=""
	for _p in \
		"/lib/security/pam_gnome_keyring.so" \
		"/lib64/security/pam_gnome_keyring.so" \
		"/usr/lib/security/pam_gnome_keyring.so" \
		"/usr/lib64/security/pam_gnome_keyring.so" \
		"/usr/lib/x86_64-linux-gnu/security/pam_gnome_keyring.so" \
		"/usr/lib/aarch64-linux-gnu/security/pam_gnome_keyring.so"; do
		if [ -f "${_p}" ]; then
			_pam_keyring="${_p}"
			break
		fi
	done

	if [ -n "${_pam_keyring}" ] && [ -f "/etc/pam.d/login" ]; then
		if ! grep -q "pam_gnome_keyring\.so" "/etc/pam.d/login" 2> "/dev/null"; then
			cat <<- EOF | ${ELEVATE} tee -a "/etc/pam.d/login" > "/dev/null" 2>&1 || true
			auth optional pam_gnome_keyring.so
			session optional pam_gnome_keyring.so auto_start
			EOF
		fi
	fi
fi

_ui_ok "Ecossistema gráfico X11, compositores e gerenciadores instalados com sucesso!"
