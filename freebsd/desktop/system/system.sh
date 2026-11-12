#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Base System Setup
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"
. "${_setup_root}/core/detect.sh"

_ui_step "Iniciando configuração base do FreeBSD..."

${ELEVATE} rm -f /etc/rc.conf\'\' /etc/sysctl.conf\'\' /boot/loader.conf\'\' /etc/*.conf\'\' /boot/*.conf\'\' 2> "/dev/null" || true

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} pw groupmod wheel -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod operator -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod video -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod webcamd -m "${TARGET_USER}" 2> "/dev/null" || true

command -v pkg > "/dev/null" 2>&1 || ${ELEVATE} pkg bootstrap -y

_target_font="${DETECTED_CONSOLE_FONT:-spleen-12x24}"
if [ "$(sysrc -n allscreens_flags 2> "/dev/null" || true)" != "-f ${_target_font}" ]; then
	${ELEVATE} sysrc allscreens_flags="-f ${_target_font}" > "/dev/null" 2>&1 || true
fi
_rcd_dir="/usr/local/etc/rc.d"
[ -d "${_rcd_dir}" ] || ${ELEVATE} mkdir -p "${_rcd_dir}"
${ELEVATE} cp "${_setup_root}/freebsd/desktop/system/vt-autofont.sh" "${_rcd_dir}/vt_autofont"
${ELEVATE} chmod 0755 "${_rcd_dir}/vt_autofont"
[ "$(sysrc -n vt_autofont_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc vt_autofont_enable="YES" > "/dev/null" 2>&1 || true
[ "$(sysrc -n moused_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc moused_enable="YES" > "/dev/null" 2>&1 || true
[ "$(sysrc -n moused_nondefault_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc moused_nondefault_enable="YES" > "/dev/null" 2>&1 || true
[ "$(sysrc -n moused_flags 2> "/dev/null" || true)" != "-A 1.5,1.5 -a 1.2" ] && ${ELEVATE} sysrc moused_flags="-A 1.5,1.5 -a 1.2" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc -x moused_port moused_type > "/dev/null" 2>&1 || true
[ "$(sysrc -n keyrate 2> "/dev/null" || true)" != "fast" ] && ${ELEVATE} sysrc keyrate="fast" > "/dev/null" 2>&1 || true
[ "$(sysrc -n background_dhclient 2> "/dev/null" || true)" != "NO" ] && ${ELEVATE} sysrc background_dhclient="NO" > "/dev/null" 2>&1 || true
[ "$(sysrc -n defaultroute_delay 2> "/dev/null" || true)" != "5" ] && ${ELEVATE} sysrc defaultroute_delay="5" > "/dev/null" 2>&1 || true
[ "$(sysrc -n ifconfig_re0 2> "/dev/null" || true)" != "DHCP" ] && ${ELEVATE} sysrc ifconfig_re0="DHCP" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc ntpdate_enable="NO" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc -x ntpdate_flags ntpdate_hosts > "/dev/null" 2>&1 || true
${ELEVATE} sysrc ntpd_enable="YES" ntpd_sync_on_start="YES" > "/dev/null" 2>&1 || true
[ "$(sysrc -n autofs_enable 2> "/dev/null" || true)" != "NO" ] && ${ELEVATE} sysrc autofs_enable="NO" rpc_statd_enable="NO" rpc_lockd_enable="NO" > "/dev/null" 2>&1 || true
[ -x "/etc/rc.d/syscons" ] && ${ELEVATE} /etc/rc.d/syscons restart > "/dev/null" 2>&1 || true
if command -v kbdcontrol > "/dev/null" 2>&1; then
	_esc=$'\e'
	${ELEVATE} kbdcontrol -f 65 "${_esc}[1;5D" -f 66 "${_esc}[1;5C" > "/dev/null" 2>&1 || true
fi

### --------------------------------
### AUDIO OSS AND SNDIOD TUNING
### --------------------------------
if ! pkg info -e sndiod > "/dev/null" 2>&1; then
	${ELEVATE} pkg install -y audio/sndiod 2> "/dev/null" || true
fi
[ "$(sysrc -n sndiod_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc sndiod_enable="YES" > "/dev/null" 2>&1 || true

${ELEVATE} sysctl kern.coredump=0 > "/dev/null" 2>&1 || true
grep -qxF "kern.coredump=0" "/etc/sysctl.conf" 2> "/dev/null" || echo "kern.coredump=0" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"

${ELEVATE} sysctl kern.vt.enable_bell=0 > "/dev/null" 2>&1 || true
grep -qxF "kern.vt.enable_bell=0" "/etc/sysctl.conf" 2> "/dev/null" || echo "kern.vt.enable_bell=0" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"

${ELEVATE} sysctl hw.snd.default_unit=1 > "/dev/null" 2>&1 || true
if sysctl dev.pcm.2 > "/dev/null" 2>&1; then
	${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 > "/dev/null" 2>&1 || true
	${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true
fi

if [ -f "/etc/sysctl.conf" ]; then
	_tmp="$(mktemp "/tmp/sysctl.conf.XXXXXX")"
	sed -e '/^dev\.pcm\.2\.mixer\./d' -e '/^hw\.snd\.default_unit=/d' "/etc/sysctl.conf" > "${_tmp}"
	echo "hw.snd.default_unit=1" >> "${_tmp}"
	${ELEVATE} cp "${_tmp}" "/etc/sysctl.conf"
	${ELEVATE} chmod 0644 "/etc/sysctl.conf"
	rm -f "${_tmp}"
fi

### --------------------------------
### DRM AND KMS GRAPHICS TUNING
### --------------------------------
if ! pkg info -e drm-66-kmod > "/dev/null" 2>&1; then
	${ELEVATE} pkg delete -f -y drm-kmod drm-612-kmod > "/dev/null" 2>&1 || true
	${ELEVATE} pkg install -y \
		graphics/drm-66-kmod \
		graphics/gpu-firmware-intel-kmod-alderlake \
		multimedia/libva-intel-media-driver \
		multimedia/libva-utils 2> "/dev/null" || true
fi
if ! pkg lock -l 2> "/dev/null" | grep -q "drm-66-kmod"; then
	${ELEVATE} pkg lock -y drm-66-kmod > "/dev/null" 2>&1 || true
fi

_kld_current="$(sysrc -n kld_list 2> "/dev/null" || true)"
if echo "${_kld_current}" | grep -q "/boot/modules/i915kms.ko"; then
	${ELEVATE} sysrc kld_list-="/boot/modules/i915kms.ko" > "/dev/null" 2>&1 || true
	_kld_current="$(sysrc -n kld_list 2> "/dev/null" || true)"
fi
case " ${_kld_current} " in
	*" i915kms "*)
		;;
	*)
		${ELEVATE} sysrc kld_list+="i915kms" > "/dev/null" 2>&1 || true
		;;
esac

_set_loader_tunable() {
	_tunable="$1"
	_value="$2"
	if grep -q "^[[:space:]]*${_tunable}=" "/boot/loader.conf" 2> "/dev/null"; then
		_tmp="$(mktemp "/tmp/loader.conf.XXXXXX")"
		sed "s|^[[:space:]]*${_tunable}=.*|${_tunable}=\"${_value}\"|" "/boot/loader.conf" > "${_tmp}"
		${ELEVATE} cp "${_tmp}" "/boot/loader.conf"
		${ELEVATE} chmod 0644 "/boot/loader.conf"
		rm -f "${_tmp}"
	else
		echo "${_tunable}=\"${_value}\"" | ${ELEVATE} tee -a "/boot/loader.conf" > "/dev/null"
	fi
}

if [ -f "/boot/loader.conf" ]; then
	_set_loader_tunable "compat.linuxkpi.i915_enable_psr" "0"
	_set_loader_tunable "compat.linuxkpi.i915_enable_psr2_sel_fetch" "0"
	_set_loader_tunable "compat.linuxkpi.i915_enable_fbc" "0"
	_set_loader_tunable "compat.linuxkpi.i915_enable_dc" "0"
	_set_loader_tunable "compat.linuxkpi.i915_enable_guc" "2"
	_set_loader_tunable "compat.linuxkpi.i915_disable_power_well" "0"
	_set_loader_tunable "kern.ipc.shmseg" "1024"
	_set_loader_tunable "kern.ipc.shmmni" "1024"
	_set_loader_tunable "kern.maxproc" "100000"
	_set_loader_tunable "compat.linuxkpi.skb.mem_limit" "1"
	_set_loader_tunable "compat.linuxkpi.rtw88_disable_lps_deep" "1"
	_set_loader_tunable "compat.linuxkpi.rtw88_pci_disable_aspm" "1"
	_set_loader_tunable "hw.pci.enable_aspm" "0"
fi

### --------------------------------
### ISOLAMENTO DE REDE E WI-FI
### --------------------------------
if [ -f "/etc/rc.conf" ]; then
	_tmp="$(mktemp "/tmp/rc.conf.XXXXXX")"
	sed -e '/^[[:space:]]*#[[:space:]]*ifconfig_wlan0=/d' -e 's| fusefs||g' "/etc/rc.conf" > "${_tmp}"
	${ELEVATE} cp "${_tmp}" "/etc/rc.conf"
	${ELEVATE} chmod 0644 "/etc/rc.conf"
	rm -f "${_tmp}"
	if grep -q "wlans_rtw880" "/etc/rc.conf" 2> "/dev/null" || grep -q "ifconfig_wlan0" "/etc/rc.conf" 2> "/dev/null"; then
		${ELEVATE} sysrc ifconfig_wlan0="WPA DHCP" > "/dev/null" 2>&1 || true
	fi
	${ELEVATE} sysrc -x ifconfig_ue0 > "/dev/null" 2>&1 || true
fi

cat <<- "EOF" | ${ELEVATE} tee "/usr/local/sbin/net-auto-switch" > "/dev/null"
#!/usr/bin/env sh
# ----------------------------------------------------------------
# Utility: Ethernet / Wi-Fi Dual-Link Auto Switcher
# ----------------------------------------------------------------
set -eu

_action="${1:-auto}"

_is_wired_active() {
	ifconfig re0 2> "/dev/null" | grep -q "status: active"
}

_switch_wired() {
	service dhclient stop wlan0 > "/dev/null" 2>&1 || true
	ifconfig wlan0 down > "/dev/null" 2>&1 || true
	if ! ifconfig re0 2> "/dev/null" | grep -q "inet "; then
		service dhclient quietstart re0 > "/dev/null" 2>&1 || true
	fi
}

_switch_wifi() {
	if ! _is_wired_active; then
		service dhclient stop re0 > "/dev/null" 2>&1 || true
		ifconfig re0 inet 0.0.0.0 > "/dev/null" 2>&1 || true
		ifconfig wlan0 up > "/dev/null" 2>&1 || true
		service wpa_supplicant restart wlan0 > "/dev/null" 2>&1 || true
	fi
}

case "${_action}" in
	wired)
		_switch_wired
		;;
	wifi)
		_switch_wifi
		;;
	auto|*)
		if _is_wired_active; then
			_switch_wired
		fi
		;;
esac
EOF
${ELEVATE} chmod 0755 "/usr/local/sbin/net-auto-switch"

cat <<- "EOF" | ${ELEVATE} tee "/usr/local/etc/rc.d/net_isolation" > "/dev/null"
#!/usr/bin/env sh
#
# PROVIDE: net_isolation
# REQUIRE: NETWORKING
# BEFORE: DAEMON
# KEYWORD: nojail
#

. /etc/rc.subr

name="net_isolation"
rcvar="net_isolation_enable"
start_cmd="net_isolation_start"

net_isolation_start() {
	if [ -x "/usr/local/sbin/net-auto-switch" ]; then
		/usr/local/sbin/net-auto-switch auto
	fi
}

load_rc_config "${name}"
: "${net_isolation_enable:=YES}"
: "${_rc_svcj:=}"
run_rc_command "$1"
EOF
${ELEVATE} chmod 0755 "/usr/local/etc/rc.d/net_isolation"
[ "$(sysrc -n net_isolation_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc net_isolation_enable="YES" > "/dev/null" 2>&1 || true

_devd_dir="/usr/local/etc/devd"
[ -d "${_devd_dir}" ] || ${ELEVATE} mkdir -p "${_devd_dir}"
cat <<- "EOF" | ${ELEVATE} tee "${_devd_dir}/ethernet-wifi-isolation.conf" > "/dev/null"
notify 100 {
	match "system" "IFNET";
	match "subsystem" "re[0-9]+";
	match "type" "LINK_UP";
	action "/usr/local/sbin/net-auto-switch wired";
};

notify 100 {
	match "system" "IFNET";
	match "subsystem" "re[0-9]+";
	match "type" "LINK_DOWN";
	action "/usr/local/sbin/net-auto-switch wifi";
};
EOF
${ELEVATE} chmod 0644 "${_devd_dir}/ethernet-wifi-isolation.conf"

mkdir -p "${HOME}/Workspace"

${ELEVATE} rm -f /etc/rc.conf\'\' /etc/sysctl.conf\'\' /boot/loader.conf\'\' /etc/*.conf\'\' /boot/*.conf\'\' 2> "/dev/null" || true

_ui_ok "Configuração base concluída com sucesso!"
