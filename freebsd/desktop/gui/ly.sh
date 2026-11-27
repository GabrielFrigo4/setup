#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Ly TUI Display Manager Configuration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando gerenciador de login Ly..."

### --------------------------------
### 1. PACKAGE AND WRAPPER
### --------------------------------
pkg info -e ly > "/dev/null" 2>&1 || ${ELEVATE} pkg install --yes x11/ly
[ "$(sysrc -n sddm_enable 2> "/dev/null" || true)" != "NO" ] && ${ELEVATE} sysrc sddm_enable="NO" > "/dev/null" 2>&1 || true
[ -e "/usr/local/bin/ly-wrapper" ] && ${ELEVATE} rm -f "/usr/local/bin/ly-wrapper"
[ -f "/usr/local/bin/ly_wrapper" ] && ${ELEVATE} chmod 0755 "/usr/local/bin/ly_wrapper"

### --------------------------------
### 2. GETTYTAB AND TTYS
### --------------------------------
if [ -f "/etc/gettytab" ]; then
	_tmp="$(mktemp "/tmp/gettytab.XXXXXX")"
	awk '
		BEGIN { skip = 0 }
		/^Ly:/ { skip = ($0 ~ /\\$/) ? 1 : 0; next }
		skip { if ($0 !~ /\\$/) skip = 0; next }
		{ lines[++n] = $0 }
		END {
			while (n > 0 && lines[n] == "") n--
			for (i = 1; i <= n; i++) print lines[i]
			printf "\nLy:\\\n\t:lo=/usr/local/bin/ly_wrapper:\\\n\t:al=root:\n"
		}
	' "/etc/gettytab" > "${_tmp}"
	${ELEVATE} cp "${_tmp}" "/etc/gettytab"
	${ELEVATE} chmod 0644 "/etc/gettytab"
	rm -f "${_tmp}"
fi

if [ -f "/etc/ttys" ]; then
	_tmp="$(mktemp "/tmp/ttys.XXXXXX")"
	awk '
		BEGIN { found = 0 }
		/^[[:space:]]*ttyv1[[:space:]]/ {
			printf "%-7s %-31s %-7s %-10s %s\n", "ttyv1", "\"/usr/libexec/getty Ly\"", "xterm", "on", "secure"
			found = 1
			next
		}
		{ print }
		END {
			if (!found) printf "%-7s %-31s %-7s %-10s %s\n", "ttyv1", "\"/usr/libexec/getty Ly\"", "xterm", "on", "secure"
		}
	' "/etc/ttys" > "${_tmp}"
	${ELEVATE} cp "${_tmp}" "/etc/ttys"
	${ELEVATE} chmod 0644 "/etc/ttys"
	rm -f "${_tmp}"
fi

### --------------------------------
### 3. LY CONFIG AND POLISH
### --------------------------------
_ly_dir="/usr/local/etc/ly"
[ -f "${_ly_dir}/setup.sh" ] || { [ -f "${_ly_dir}/setup.sh.sample" ] && ${ELEVATE} cp "${_ly_dir}/setup.sh.sample" "${_ly_dir}/setup.sh"; }
[ -f "${_ly_dir}/setup.sh" ] && ${ELEVATE} chmod 0755 "${_ly_dir}/setup.sh"
[ -f "${_ly_dir}/config.ini" ] || { [ -f "${_ly_dir}/config.ini.sample" ] && ${ELEVATE} cp "${_ly_dir}/config.ini.sample" "${_ly_dir}/config.ini"; }

_set_ini() {
	_ini="$1"; _k="$2"; _v="$3"
	_tmp="$(mktemp "/tmp/ly.ini.XXXXXX")"
	if grep -Eq "^[[:space:]]*${_k}[[:space:]]*=" "${_ini}" 2> "/dev/null"; then
		awk -v key="${_k}" -v val="${_v}" '
			$0 ~ "^[[:space:]]*" key "[[:space:]]*=" { print key " = " val; next }
			{ print }
		' "${_ini}" > "${_tmp}"
	else
		cat "${_ini}" > "${_tmp}"
		printf "%s = %s\n" "${_k}" "${_v}" >> "${_tmp}"
	fi
	${ELEVATE} cp "${_tmp}" "${_ini}"
	${ELEVATE} chmod 0644 "${_ini}"
	rm -f "${_tmp}"
}

if [ -f "${_ly_dir}/config.ini" ]; then
	for _pair in \
		"full_color=false" \
		"bg=0x00000000" \
		"fg=0x00000008" \
		"border_fg=0x00000007" \
		"error_bg=0x00000000" \
		"error_fg=0x01000002" \
		"start_cmd=null" \
		"x_vt=9" \
		"lang=en" \
		"allow_empty_password=false" \
		"clear_password=true" \
		"hide_version_string=true" \
		"clock=%a %d/%m %H:%M" \
		"animation=gameoflife" \
		"animation_frame_delay=5" \
		"animation_timeout_sec=0" \
		"gameoflife_fg=0x00000005" \
		"gameoflife_frame_delay=10" \
		"gameoflife_initial_density=0.25" \
		"gameoflife_entropy_interval=25" \
		"blank_box=true" \
		"hide_borders=false" \
		"save=true"; do
		_set_ini "${_ly_dir}/config.ini" "${_pair%%=*}" "${_pair#*=}"
	done
fi

### --------------------------------
### 4. LOG ROTATION
### --------------------------------
${ELEVATE} mkdir -p "/usr/local/etc/newsyslog.conf.d"
cat <<- "EOF" | ${ELEVATE} tee "/usr/local/etc/newsyslog.conf.d/ly.conf" > "/dev/null"
	/var/log/ly.log                         644  5     512  *     JNC
EOF
${ELEVATE} chmod 0644 "/usr/local/etc/newsyslog.conf.d/ly.conf"

_ui_ok "Gerenciador de login Ly configurado com sucesso!"
