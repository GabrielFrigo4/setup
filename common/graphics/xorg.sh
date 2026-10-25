#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: X11 Server, Tools & Micro-Window Managers Suite
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v xinit > "/dev/null" 2>&1 && command -v xterm > "/dev/null" 2>&1 && command -v xrdb > "/dev/null" 2>&1 && (command -v matchbox-window-manager > "/dev/null" 2>&1 || command -v openbox > "/dev/null" 2>&1 || command -v cwm > "/dev/null" 2>&1); then
	_ui_ok "Servidor X11, utilitários e gerenciadores de quiosque já instalados."
	exit 0
fi

_ui_step "Instalando ecossistema gráfico X11 (Xorg, xinit, xterm, xrdb, xdotool e micro-WMs)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		x11/xorg-minimal \
		x11/xinit \
		x11/xterm \
		x11/xrdb \
		x11/xdotool \
		x11-wm/openbox \
		x11-wm/matchbox-window-manager 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		xorg-x11-server-Xorg \
		xorg-x11-xinit \
		xterm \
		xrdb \
		xdotool \
		openbox \
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
		matchbox-window-manager \
		openbox 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		xorg-server \
		xorg-xinit \
		xterm \
		xorg-xrdb \
		xdotool \
		openbox
	if command -v yay > "/dev/null" 2>&1; then
		yay -S --needed --noconfirm matchbox-window-manager 2> "/dev/null" || true
	fi
else
	_ui_err "Gerenciador de pacotes não suportado para instalação do ecossistema X11."
	exit 1
fi

if [ -d "/etc/X11" ]; then
	cat << EOF | ${ELEVATE} tee /etc/X11/Xwrapper.config > "/dev/null" 2>&1 || true
allowed_users = anybody
needs_root_rights = auto
EOF
	${ELEVATE} chmod 0644 /etc/X11/Xwrapper.config 2> "/dev/null" || true
fi

_ui_ok "Ecossistema gráfico X11 e micro-gerenciadores instalados com sucesso!"
