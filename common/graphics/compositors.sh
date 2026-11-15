#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Wayland Compositors & Launchers Suite
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_install_resilient() {
	_mgr="$1"
	[ "$#" -ge 1 ] && shift
	case "${_mgr}" in
		pkg)
			if ! ${ELEVATE} pkg install --yes "$@" 2> "/dev/null"; then
				for _pkg in "$@"; do
					${ELEVATE} pkg install --yes "${_pkg}" 2> "/dev/null" || true
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
	esac
}

_ui_step "Provisionando compositores Wayland, launchers (wofi, fuzzel), seatd e foot..."

if command -v pkg > "/dev/null" 2>&1; then
	_install_resilient pkg \
		x11-wm/sway x11-wm/river x11-wm/labwc x11-wm/cage \
		x11-wm/wayfire x11-wm/niri x11-wm/hikari x11-servers/weston \
		x11-wm/hyprland x11-wm/dwl sysutils/seatd x11/foot x11/wlr-randr \
		x11/wofi x11/fuzzel x11-themes/kf6-breeze-icons \
		x11-themes/adwaita-icon-theme
	${ELEVATE} sysrc seatd_enable="YES" > "/dev/null" 2>&1 || true
	_target_user="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	${ELEVATE} pw groupmod video -m "${_target_user}" 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	_fedora_pkgs="sway river labwc cage wayfire niri hikari weston \
		seatd foot wlr-randr wofi fuzzel breeze-cursor-theme \
		breeze-icon-theme adwaita-icon-theme"
	_missing=""
	for _pkg in ${_fedora_pkgs}; do
		rpm -q "${_pkg}" > "/dev/null" 2>&1 || _missing="${_missing} ${_pkg}"
	done
	if [ -n "${_missing}" ]; then
		_install_resilient dnf ${_missing} hyprland dwl
	fi
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now seatd.service 2> "/dev/null" || true
	fi
	_target_user="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	${ELEVATE} usermod -aG video,input "${_target_user}" 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	_install_resilient apt-get \
		sway river labwc cage wayfire niri hikari weston \
		seatd foot wlr-randr wofi fuzzel breeze-cursor-theme \
		breeze-icon-theme adwaita-icon-theme
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now seatd.service 2> "/dev/null" || true
	fi
	_target_user="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	${ELEVATE} usermod -aG video,input "${_target_user}" 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	_install_resilient pacman \
		sway river labwc cage wayfire niri weston hyprland \
		seatd foot wlr-randr wofi fuzzel breeze-cursors \
		breeze-icons adwaita-icon-theme
	if command -v yay > "/dev/null" 2>&1; then
		_install_resilient yay hikari dwl
	fi
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now seatd.service 2> "/dev/null" || true
	fi
	_target_user="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	${ELEVATE} usermod -aG video,input "${_target_user}" 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado para instalação de compositores Wayland."
	exit 1
fi

_ui_ok "Compositores Wayland e utilitários provisionados com sucesso!"
