#!/usr/bin/env sh
# ----------------------------------------------------------------
# Helper: Universal Dynamic Virtual Console Font Scaler
# ----------------------------------------------------------------
set -eu

_install_service_hooks() {
	if [ -d "/etc/udev/rules.d" ] || [ -d "/lib/udev/rules.d" ]; then
		_udev_dir="/etc/udev/rules.d"
		[ -d "${_udev_dir}" ] || mkdir -p "${_udev_dir}"
		echo 'ACTION=="add", SUBSYSTEM=="vtconsole", KERNEL=="vtcon*", RUN+="/usr/local/libexec/vconsole-autofont"' > "${_udev_dir}/90-vconsole-autofont.rules"
	fi

	if command -v systemctl > "/dev/null" 2>&1; then
		_vconsole_dropin="/etc/systemd/system/systemd-vconsole-setup.service.d"
		[ -d "${_vconsole_dropin}" ] || mkdir -p "${_vconsole_dropin}"
		cat <<- "EOF" > "${_vconsole_dropin}/autofont.conf"
		[Service]
		ExecStartPre=-/usr/local/libexec/vconsole-autofont
		EOF
	elif command -v rc-update > "/dev/null" 2>&1 && [ -d "/etc/init.d" ]; then
		cat <<- "EOF" > "/etc/init.d/vconsole-autofont"
		#!/sbin/openrc-run
		description="Dynamic Console Font Scaler"
		depend() { after udev; before login; }
		start() { /usr/local/libexec/vconsole-autofont; }
		EOF
		chmod 0755 "/etc/init.d/vconsole-autofont"
		rc-update add vconsole-autofont boot > "/dev/null" 2>&1 || true
	elif [ -d "/etc/init.d" ] && command -v update-rc.d > "/dev/null" 2>&1; then
		cat <<- "EOF" > "/etc/init.d/vconsole-autofont"
		#!/bin/sh
		### BEGIN INIT INFO
		# Provides:          vconsole-autofont
		# Required-Start:    $local_fs
		# Default-Start:     S 2 3 4 5
		# Short-Description: Dynamic Console Font Scaler
		### END INIT INFO
		/usr/local/libexec/vconsole-autofont
		EOF
		chmod 0755 "/etc/init.d/vconsole-autofont"
		update-rc.d vconsole-autofont defaults > "/dev/null" 2>&1 || true
	fi
}

[ "${1:-}" = "--setup" ] && { _install_service_hooks; exit 0; }

_height=0
for _card in /sys/class/drm/card*-*; do
	[ -f "${_card}/status" ] || continue
	if [ "$(cat "${_card}/status" 2> "/dev/null")" = "connected" ] && [ -f "${_card}/modes" ]; then
		read -r _mode < "${_card}/modes"
		_h="${_mode#*x}"
		_h="${_h%%[^0-9]*}"
		[ -n "${_h}" ] && [ "${_h}" -gt "${_height}" ] && _height="${_h}"
	fi
done

if [ "${_height}" -eq 0 ] && [ -f "/sys/class/graphics/fb0/virtual_size" ]; then
	_fb_h="$(cut -d, -f2 "/sys/class/graphics/fb0/virtual_size" 2> "/dev/null" || true)"
	[ -n "${_fb_h}" ] && _height="${_fb_h}"
fi

_font="spleen-12x24"
if [ "${_height}" -ge 2160 ]; then
	[ "${SPLEEN_DENSE:-0}" = "1" ] && _font="spleen-16x32" || _font="spleen-32x64"
elif [ "${_height}" -ge 1440 ]; then
	_font="spleen-16x32"
fi

if [ -f "/etc/vconsole.conf" ]; then
	_cur="$(grep "^[[:space:]]*FONT=" "/etc/vconsole.conf" 2> "/dev/null" | head -n 1 | cut -d= -f2 | tr -d '"'\')"
	if [ "${_cur}" != "${_font}" ]; then
		if grep -q "^[[:space:]]*FONT=" "/etc/vconsole.conf" 2> "/dev/null"; then
			sed -i "s|^[[:space:]]*FONT=.*|FONT=\"${_font}\"|" "/etc/vconsole.conf"
		else
			echo "FONT=\"${_font}\"" >> "/etc/vconsole.conf"
		fi
	fi
fi

if [ -f "/etc/default/console-setup" ]; then
	_fontsize="${_font#spleen-}"
	_cur_sz="$(grep "^[[:space:]]*FONTSIZE=" "/etc/default/console-setup" 2> "/dev/null" | head -n 1 | cut -d= -f2 | tr -d '"'\')"
	if [ "${_cur_sz}" != "${_fontsize}" ]; then
		sed -i 's|^[[:space:]]*FONTFACE=.*|FONTFACE="Spleen"|' "/etc/default/console-setup"
		sed -i "s|^[[:space:]]*FONTSIZE=.*|FONTSIZE=\"${_fontsize}\"|" "/etc/default/console-setup"
		command -v setupcon > "/dev/null" 2>&1 && setupcon > "/dev/null" 2>&1 || true
	fi
fi

if command -v setfont > "/dev/null" 2>&1; then
	setfont "${_font}" > "/dev/null" 2>&1 || true
fi
