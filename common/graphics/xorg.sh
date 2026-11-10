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

if command -v xinit > "/dev/null" 2>&1 && \
	command -v xterm > "/dev/null" 2>&1 && \
	command -v xrdb > "/dev/null" 2>&1 && \
	command -v openbox > "/dev/null" 2>&1 && \
	command -v cwm > "/dev/null" 2>&1 && \
	command -v dwm > "/dev/null" 2>&1 && \
	command -v picom > "/dev/null" 2>&1 && \
	command -v xsettingsd > "/dev/null" 2>&1 && \
	{ [ "${_is_bsd}" -eq 1 ] || command -v matchbox-window-manager > "/dev/null" 2>&1; }; then
	_ui_ok "Servidor X11, utilitários, compositores e gerenciadores já instalados."
	exit 0
fi

_ui_step "Instalando ecossistema gráfico X11, compositores e gerenciadores..."

### --------------------------------
### 1. INSTALACAO DE PACOTES
### --------------------------------
if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install -y \
		x11/xorg-minimal \
		x11/xinit \
		x11/xterm \
		x11/xrdb \
		x11/xdotool \
		x11-wm/openbox \
		x11-wm/cwm \
		x11-wm/dwm \
		x11-wm/picom \
		x11-wm/xcompmgr \
		x11/xsettingsd \
		security/gnome-keyring \
		security/libsecret \
		x11-themes/adwaita-icon-theme \
		x11-themes/kf6-breeze-icons 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		xorg-x11-server-Xorg \
		xorg-x11-xinit \
		xterm \
		xrdb \
		xdotool \
		openbox \
		cwm \
		dwm \
		picom \
		xcompmgr \
		xsettingsd \
		gnome-keyring \
		libsecret \
		adwaita-icon-theme \
		adwaita-icon-theme-legacy \
		breeze-icon-theme \
		xorg-x11-drv-intel \
		xorg-x11-drv-amdgpu \
		xorg-x11-drv-nouveau 2> "/dev/null" || true
	${ELEVATE} dnf install --assumeyes matchbox-window-manager 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		xserver-xorg \
		xinit \
		xterm \
		x11-xserver-utils \
		xdotool \
		openbox \
		cwm \
		dwm \
		picom \
		xcompmgr \
		xsettingsd \
		gnome-keyring \
		libsecret-1-0 \
		libsecret-tools \
		adwaita-icon-theme \
		breeze-icon-theme \
		matchbox-window-manager 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		xorg-server \
		xorg-xinit \
		xterm \
		xorg-xrdb \
		xdotool \
		openbox \
		cwm \
		dwm \
		picom \
		xcompmgr \
		xsettingsd \
		gnome-keyring \
		libsecret \
		adwaita-icon-theme \
		breeze-icons 2> "/dev/null" || true
	if command -v yay > "/dev/null" 2>&1; then
		yay -S --needed --noconfirm matchbox-window-manager 2> "/dev/null" || true
	fi
elif command -v pkg_add > "/dev/null" 2>&1; then
	${ELEVATE} pkg_add -I \
		xdotool \
		openbox \
		cwm \
		dwm \
		picom \
		xcompmgr \
		xsettingsd \
		gnome-keyring \
		libsecret \
		adwaita-icon-theme \
		breeze-icons 2> "/dev/null" || true
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
_xorg_conf_dir="/etc/X11/xorg.conf.d"
[ "$(uname -s)" = "FreeBSD" ] && _xorg_conf_dir="/usr/local/etc/X11/xorg.conf.d"

if [ -d "/etc/X11" ] || [ "$(uname -s)" = "FreeBSD" ]; then
	${ELEVATE} mkdir -p "${_xorg_conf_dir}" 2> "/dev/null" || true
	cat <<- "EOF" | ${ELEVATE} tee "${_xorg_conf_dir}/20-tearfree.conf" > "/dev/null" 2>&1 || true
	Section "Device"
		Identifier "Intel Graphics"
		Driver "intel"
		Option "TearFree" "true"
	EndSection

	Section "Device"
		Identifier "AMD Graphics"
		Driver "amdgpu"
		Option "TearFree" "true"
	EndSection

	Section "Device"
		Identifier "Radeon Graphics"
		Driver "radeon"
		Option "TearFree" "true"
	EndSection
	EOF
	${ELEVATE} chmod 0644 "${_xorg_conf_dir}/20-tearfree.conf" 2> "/dev/null" || true
fi

### --------------------------------
### 4. AUTO-UNLOCK GNOME KEYRING
### --------------------------------
_pam_keyring=""
for _p in \
	"/lib/security/pam_gnome_keyring.so" \
	"/lib64/security/pam_gnome_keyring.so" \
	"/usr/lib/security/pam_gnome_keyring.so" \
	"/usr/lib64/security/pam_gnome_keyring.so" \
	"/usr/lib/x86_64-linux-gnu/security/pam_gnome_keyring.so" \
	"/usr/lib/aarch64-linux-gnu/security/pam_gnome_keyring.so" \
	"/usr/local/lib/pam_gnome_keyring.so"; do
	if [ -f "${_p}" ]; then
		_pam_keyring="${_p}"
		break
	fi
done

if [ -n "${_pam_keyring}" ] && [ -f "/etc/pam.d/login" ]; then
	if ! grep -q "pam_gnome_keyring\.so" "/etc/pam.d/login" 2> "/dev/null"; then
		_keyring_mod="pam_gnome_keyring.so"
		[ "$(uname -s)" = "FreeBSD" ] && _keyring_mod="/usr/local/lib/pam_gnome_keyring.so"
		cat <<- EOF | ${ELEVATE} tee -a "/etc/pam.d/login" > "/dev/null" 2>&1 || true
		auth optional ${_keyring_mod}
		session optional ${_keyring_mod} auto_start
		EOF
	fi
fi

_ui_ok "Ecossistema gráfico X11, compositores e gerenciadores instalados com sucesso!"
