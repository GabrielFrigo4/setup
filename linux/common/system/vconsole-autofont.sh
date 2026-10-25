#!/usr/bin/env sh
# ----------------------------------------------------------------
# Helper: Dynamic Virtual Console Font Scaler
# ----------------------------------------------------------------
set -eu

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
[ "${_height}" -ge 1440 ] && _font="spleen-16x32"

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
