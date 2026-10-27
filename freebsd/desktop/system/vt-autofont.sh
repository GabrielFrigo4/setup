#!/usr/bin/env sh
# ----------------------------------------------------------------
# Helper: FreeBSD Virtual Terminal Dynamic Console Font Scaler
# ----------------------------------------------------------------

set -eu

. /etc/rc.subr

name="vt_autofont"
rcvar="vt_autofont_enable"
start_cmd="vt_autofont_start"

vt_autofont_start() {
	_height=0
	_mode="$(sysctl -n kern.vt.fb.default_mode 2> "/dev/null" || kenv -q kern.vt.fb.default_mode 2> "/dev/null" || true)"
	if [ -n "${_mode}" ]; then
		_h="${_mode#*x}"
		_h="${_h%%[^0-9]*}"
		[ -n "${_h}" ] && _height="${_h}"
	fi
	if [ "${_height}" -eq 0 ]; then
		_h="$({ dmesg 2> "/dev/null" || cat "/var/run/dmesg.boot" 2> "/dev/null" || true; } | grep -E "VT\(|drm|fb|mode|resolution" | grep -Eo "[0-9]{3,4}x[0-9]{3,4}" | tail -n 1 | cut -d'x' -f2 || true)"
		[ -n "${_h}" ] && _height="${_h}"
	fi

	if [ "${_height}" -ge 2160 ]; then
		[ "${SPLEEN_DENSE:-0}" = "1" ] && _font="spleen-16x32" || _font="spleen-32x64"
	elif [ "${_height}" -ge 1440 ]; then
		_font="spleen-16x32"
	elif [ "${_height}" -ge 1080 ]; then
		_font="spleen-12x24"
	else
		_font="spleen-8x16"
	fi

	_cur_flags="$(sysrc -n allscreens_flags 2> "/dev/null" || echo "")"
	case "${_cur_flags}" in
		*"-f ${_font}"*) ;;
		*)
			sysrc allscreens_flags="-f ${_font}" > "/dev/null" 2>&1 || true
			;;
	esac

	if [ -f "/usr/share/vt/fonts/${_font}.fnt" ]; then
		for _tty in /dev/ttyv*; do
			[ -c "${_tty}" ] && vidcontrol -f "/usr/share/vt/fonts/${_font}.fnt" < "${_tty}" > "/dev/null" 2>&1 || true
		done
	fi
}

load_rc_config "${name}"
: "${vt_autofont_enable:=YES}"
run_rc_command "$1"
