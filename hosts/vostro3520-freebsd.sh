#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Dell Vostro 3520 FreeBSD Hardware Quirks (Opt-In)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Aplicando ajustes de hardware para Dell Vostro 3520 (FreeBSD)..."

_set_kv() {
	_f="$1"; _k="$2"; _v="$3"; _q="${4:-}"
	if grep -q "^[[:space:]]*${_k}=" "${_f}" 2> "/dev/null"; then
		_tmp="$(mktemp "/tmp/vostro_kv.XXXXXX")"
		sed "s|^[[:space:]]*${_k}=.*|${_k}=${_q}${_v}${_q}|" "${_f}" > "${_tmp}"
		${ELEVATE} cp "${_tmp}" "${_f}"
		${ELEVATE} chmod 0644 "${_f}"
		rm -f "${_tmp}"
	else
		echo "${_k}=${_q}${_v}${_q}" | ${ELEVATE} tee -a "${_f}" > "/dev/null"
	fi
}
### --------------------------------
### INTEL ALDER LAKE DRM
### --------------------------------
_fb_ver="$(freebsd-version -u 2> "/dev/null" || uname -r)"; _fb_num="${_fb_ver%%-*}"
_fb_maj="${_fb_num%%.*}"; _fb_maj="${_fb_maj%%[!0-9]*}"; _fb_min="${_fb_num#*.}"; _fb_min="${_fb_min%%[!0-9]*}"

if [ "${_fb_maj:-15}" -lt 15 ] || { [ "${_fb_maj:-15}" -eq 15 ] && [ "${_fb_min:-0}" -lt 2 ]; }; then
	if ! pkg info -e drm-66-kmod > "/dev/null" 2>&1; then
		${ELEVATE} pkg delete -f -y drm-kmod drm-612-kmod > "/dev/null" 2>&1 || true
		${ELEVATE} pkg install --yes graphics/drm-66-kmod graphics/gpu-firmware-intel-kmod-alderlake \
			multimedia/libva-intel-media-driver multimedia/libva-utils 2> "/dev/null" || true
	fi
	pkg lock -l 2> "/dev/null" | grep -q "drm-66-kmod" || ${ELEVATE} pkg lock -y drm-66-kmod > "/dev/null" 2>&1 || true
else
	pkg lock -l 2> "/dev/null" | grep -q "drm-66-kmod" && ${ELEVATE} pkg unlock -y drm-66-kmod > "/dev/null" 2>&1 || true
	${ELEVATE} pkg install --yes graphics/drm-kmod graphics/gpu-firmware-intel-kmod-alderlake \
		multimedia/libva-intel-media-driver multimedia/libva-utils 2> "/dev/null" || true
fi

case " $(sysrc -n kld_list 2> "/dev/null" || true) " in *"/boot/modules/i915kms.ko"*) ${ELEVATE} sysrc kld_list-="/boot/modules/i915kms.ko" > "/dev/null" 2>&1 || true ;; esac
case " $(sysrc -n kld_list 2> "/dev/null" || true) " in *" i915kms "*) ;; *) ${ELEVATE} sysrc kld_list+="i915kms" > "/dev/null" 2>&1 || true ;; esac

### --------------------------------
### LOADER TUNABLES
### --------------------------------
if [ -f "/boot/loader.conf" ]; then
	for _e in "compat.linuxkpi.i915_enable_psr=0" "compat.linuxkpi.i915_enable_psr2_sel_fetch=0" \
		"compat.linuxkpi.i915_enable_fbc=0" "compat.linuxkpi.i915_enable_dc=0" \
		"compat.linuxkpi.i915_enable_guc=2" "compat.linuxkpi.i915_disable_power_well=0" \
		"kern.ipc.shmseg=1024" "kern.ipc.shmmni=1024" "kern.maxproc=100000" \
		"compat.linuxkpi.skb.mem_limit=1" "compat.linuxkpi.rtw88_disable_lps_deep=1" \
		"compat.linuxkpi.rtw88_pci_disable_aspm=1" "hw.pci.enable_aspm=0" \
		"if_re_load=YES" "if_re_name=/boot/modules/if_re.ko" "uplcom_load=YES" "ng_ubt_load=YES"; do
		_set_kv "/boot/loader.conf" "${_e%%=*}" "${_e#*=}" '"'
	done
fi

### --------------------------------
### REALTEK NIC AND RTW880 WI-FI
### --------------------------------
pkg info -e realtek-re-kmod > "/dev/null" 2>&1 || ${ELEVATE} pkg install --yes net/realtek-re-kmod 2> "/dev/null" || true
pkg info -x "^wifi-firmware-rtw88-kmod" > "/dev/null" 2>&1 || ${ELEVATE} pkg install --yes wifi-firmware-rtw88-kmod-rtw8821c 2> "/dev/null" || true
for _sr in "ifconfig_re0=DHCP" "ifconfig_re0_ipv6=inet6 auto_linklocal" "wlans_rtw880=wlan0" \
	"create_args_wlan0=country BR regdomain FCC" "wpa_supplicant_enable=YES" "ifconfig_wlan0=WPA DHCP -bgscan" \
	"ifconfig_wlan0_ipv6=inet6 auto_linklocal" "rtsold_enable=NO" "background_dhclient=YES" "net_isolation_enable=YES"; do
	${ELEVATE} sysrc "${_sr}" > "/dev/null" 2>&1 || true
done
${ELEVATE} sysrc -x ifconfig_ue0 rtsold_flags > "/dev/null" 2>&1 || true

cat <<- "EOF" | ${ELEVATE} tee "/usr/local/sbin/net-auto-switch" > "/dev/null"
	#!/usr/bin/env sh
	set -eu
	_act="${1:-auto}"
	_wired_up() { ifconfig re0 2> "/dev/null" | grep -q "status: active"; }
	_stop_rtsold() { service rtsold onestop > "/dev/null" 2>&1 || pkill -x rtsold > "/dev/null" 2>&1 || true; }
	_switch_wired() {
		_stop_rtsold
		service dhclient stop wlan0 > "/dev/null" 2>&1 || true
		resolvconf -d wlan0 > "/dev/null" 2>&1 || true
		resolvconf -d wlan0:slaac > "/dev/null" 2>&1 || true
		ifconfig wlan0 inet6 -accept_rtadv ifdisabled > "/dev/null" 2>&1 || true
		ifconfig wlan0 down > "/dev/null" 2>&1 || true
		ifconfig re0 inet6 -ifdisabled accept_rtadv > "/dev/null" 2>&1 || true
		ifconfig re0 2> "/dev/null" | grep -q "inet " || service dhclient quietstart re0 > "/dev/null" 2>&1 || true
		/usr/sbin/rtsold -i -F -m -p "/var/run/rtsold.pid" re0 > "/dev/null" 2>&1 || true
	}
	_switch_wifi() {
		[ "${1:-0}" -eq 1 ] && sleep 2
		if ! _wired_up; then
			_stop_rtsold
			service dhclient stop re0 > "/dev/null" 2>&1 || true
			resolvconf -d re0 > "/dev/null" 2>&1 || true
			resolvconf -d re0:slaac > "/dev/null" 2>&1 || true
			ifconfig re0 inet 0.0.0.0 > "/dev/null" 2>&1 || true
			ifconfig re0 inet6 -accept_rtadv ifdisabled > "/dev/null" 2>&1 || true
			ifconfig wlan0 inet6 -ifdisabled accept_rtadv up > "/dev/null" 2>&1 || true
			pgrep -f "wpa_supplicant.*wlan0" > "/dev/null" 2>&1 && wpa_cli -i wlan0 reconfigure > "/dev/null" 2>&1 || service wpa_supplicant restart wlan0 > "/dev/null" 2>&1 || true
			/usr/sbin/rtsold -i -F -m -p "/var/run/rtsold.pid" wlan0 > "/dev/null" 2>&1 || true
		fi
	}
	case "${_act}" in
		wired) _switch_wired ;;
		wifi) _switch_wifi 1 ;;
		auto|*) if _wired_up; then _switch_wired; else _switch_wifi 0; fi ;;
	esac
EOF
${ELEVATE} chmod 0755 "/usr/local/sbin/net-auto-switch"

cat <<- "EOF" | ${ELEVATE} tee "/usr/local/etc/rc.d/net_isolation" > "/dev/null"
	#!/usr/bin/env sh
	# PROVIDE: net_isolation
	# REQUIRE: NETWORKING
	# BEFORE: DAEMON
	# KEYWORD: nojail
	. /etc/rc.subr
	name="net_isolation"; rcvar="net_isolation_enable"
	start_cmd="[ -x /usr/local/sbin/net-auto-switch ] && /usr/local/sbin/net-auto-switch auto"
	load_rc_config "${name}"; : "${net_isolation_enable:=YES}"; : "${_rc_svcj:=}"; run_rc_command "$1"
EOF
${ELEVATE} chmod 0755 "/usr/local/etc/rc.d/net_isolation"

${ELEVATE} mkdir -p "/usr/local/etc/devd"
cat <<- "EOF" | ${ELEVATE} tee "/usr/local/etc/devd/ethernet-wifi-isolation.conf" > "/dev/null"
	notify 100 { match "system" "IFNET"; match "subsystem" "re[0-9]+"; match "type" "LINK_UP"; action "/usr/local/sbin/net-auto-switch wired &"; };
	notify 100 { match "system" "IFNET"; match "subsystem" "re[0-9]+"; match "type" "LINK_DOWN"; action "/usr/local/sbin/net-auto-switch wifi &"; };
EOF
${ELEVATE} chmod 0644 "/usr/local/etc/devd/ethernet-wifi-isolation.conf"

### --------------------------------
### AUDIO AND ACPI QUIRKS
### --------------------------------
for _sc in "hw.snd.default_unit=1" "hw.acpi.lid_switch_state=S5"; do
	${ELEVATE} sysctl "${_sc}" > "/dev/null" 2>&1 || true
	_set_kv "/etc/sysctl.conf" "${_sc%%=*}" "${_sc#*=}" ""
done
sysctl dev.pcm.2 > "/dev/null" 2>&1 && ${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true
sysrc -q virtual_oss_default_control_device 2> "/dev/null" || ${ELEVATE} sysrc virtual_oss_default_control_device="" > "/dev/null" 2>&1 || true
for _df in /etc/devd/*.conf /usr/local/etc/devd/*.conf; do
	[ -f "${_df}" ] && grep -Eq "virtual_oss_cmd|virtual_oss_default_control_device" "${_df}" 2> "/dev/null" || continue
	_bak="$(mktemp "/tmp/devd.conf.XXXXXX")"; cp "${_df}" "${_bak}"
	${ELEVATE} sed -i '' -e ':a' -e '/\\$/N; s/\\\n[[:space:]]*/ /; ta' -E \
		-e 's|ctl=\$\(sysrc[[:space:]]+-qn[[:space:]]+virtual_oss_default_control_device[^;]*;[[:space:]]*\[[[:space:]]*-n[[:space:]]+\\?"\$\{ctl\}\\?"[[:space:]]*\][[:space:]]*&&[[:space:]]*\[[[:space:]]*-e[[:space:]]+\\?"/dev/\$\{ctl\}\\?"[[:space:]]*\][[:space:]]*&&[[:space:]]*(/usr/sbin/)?virtual_oss_cmd[[:space:]]+/dev/\$\{ctl\}|ctl=$(sysrc -qn virtual_oss_default_control_device 2>'\''/dev/null'\''); [ -c /dev/${ctl:-nonexistent} ] \&\& /usr/sbin/virtual_oss_cmd /dev/${ctl}|g' \
		-e 's|(/usr/sbin/)?virtual_oss_cmd[[:space:]]+/dev/\$\(sysrc[[:space:]]+(-[a-zA-Z]*n[a-zA-Z]*[[:space:]]+)?virtual_oss_default_control_device\)|ctl=$(sysrc -qn virtual_oss_default_control_device 2>'\''/dev/null'\''); [ -c /dev/${ctl:-nonexistent} ] \&\& /usr/sbin/virtual_oss_cmd /dev/${ctl}|g' "${_df}" 2> "/dev/null" || true
	command -v devd > "/dev/null" 2>&1 && command -v timeout > "/dev/null" 2>&1 && { _st=0; ${ELEVATE} timeout 1 devd -d -f "${_df}" > "/dev/null" 2>&1 || _st=$?; [ "${_st}" -ne 0 ] && [ "${_st}" -ne 124 ] && ${ELEVATE} cp "${_bak}" "${_df}"; }
	rm -f "${_bak}"
done

_ui_ok "Quirks de hardware Dell Vostro 3520 aplicados com sucesso!"
