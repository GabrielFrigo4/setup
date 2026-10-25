#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wayland Micro-Compositors Suite
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v sway > "/dev/null" 2>&1 && command -v river > "/dev/null" 2>&1 && command -v labwc > "/dev/null" 2>&1 && command -v cage > "/dev/null" 2>&1 && command -v foot > "/dev/null" 2>&1 && command -v seatd > "/dev/null" 2>&1; then
	_ui_ok "Micro-compositores Wayland já instalados."
	exit 0
fi

_ui_step "Instalando a tétrade de micro-compositores Wayland (sway, river, labwc, cage), seatd e foot..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		x11-wm/sway \
		x11-wm/river \
		x11-wm/labwc \
		x11-wm/cage \
		sysutils/seatd \
		x11/foot \
		x11/wlr-randr \
		x11-themes/breeze-icons \
		x11-themes/adwaita-icon-theme
	${ELEVATE} sysrc seatd_enable="YES" > "/dev/null" 2>&1 || true
	_target_user="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	${ELEVATE} pw groupmod video -m "${_target_user}" 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		sway \
		river \
		labwc \
		cage \
		seatd \
		foot \
		wlr-randr \
		breeze-cursor-theme \
		adwaita-icon-theme
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now seatd.service 2> "/dev/null" || true
	fi
	_target_user="${SUDO_USER:-$(id -un)}"
	${ELEVATE} usermod -aG video,input "${_target_user}" 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		sway \
		river \
		labwc \
		cage \
		seatd \
		foot \
		wlr-randr \
		breeze-cursor-theme \
		adwaita-icon-theme 2> "/dev/null" || true
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now seatd.service 2> "/dev/null" || true
	fi
	_target_user="${SUDO_USER:-$(id -un)}"
	${ELEVATE} usermod -aG video,input "${_target_user}" 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		sway \
		river \
		labwc \
		cage \
		seatd \
		foot \
		wlr-randr \
		breeze-cursors \
		adwaita-icon-theme
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now seatd.service 2> "/dev/null" || true
	fi
	_target_user="${SUDO_USER:-$(id -un)}"
	${ELEVATE} usermod -aG video,input "${_target_user}" 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado para instalação de micro-compositores."
	exit 1
fi

_ui_ok "Tétrade de micro-compositores Wayland instalada com sucesso!"
