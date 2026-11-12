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

for _grp in wheel operator video webcamd; do
	${ELEVATE} pw groupmod "${_grp}" -m "${TARGET_USER}" 2> "/dev/null" || true
done

command -v pkg > "/dev/null" 2>&1 || ${ELEVATE} pkg bootstrap -y

_target_font="${DETECTED_CONSOLE_FONT:-spleen-12x24}"
if [ "$(sysrc -n allscreens_flags 2> "/dev/null" || true)" != "-f ${_target_font}" ]; then
	${ELEVATE} sysrc allscreens_flags="-f ${_target_font}" > "/dev/null" 2>&1 || true
fi
_rcd_dir="/usr/local/etc/rc.d"
[ -d "${_rcd_dir}" ] || ${ELEVATE} mkdir -p "${_rcd_dir}"
${ELEVATE} cp "${_setup_root}/freebsd/desktop/system/vt-autofont.sh" "${_rcd_dir}/vt_autofont"
${ELEVATE} chmod 0755 "${_rcd_dir}/vt_autofont"
for _sr in "vt_autofont_enable=YES" "moused_enable=YES" "moused_nondefault_enable=YES" \
	"moused_flags=-A 1.5,1.5 -a 1.2" "keyrate=fast" "background_dhclient=NO" \
	"defaultroute_delay=5" "ifconfig_re0=DHCP"; do
	_k="${_sr%%=*}"; _v="${_sr#*=}"
	[ "$(sysrc -n "${_k}" 2> "/dev/null" || true)" != "${_v}" ] && ${ELEVATE} sysrc "${_sr}" > "/dev/null" 2>&1 || true
done
${ELEVATE} sysrc -x moused_port moused_type > "/dev/null" 2>&1 || true
${ELEVATE} sysrc ntpdate_enable="NO" ntpd_enable="YES" ntpd_sync_on_start="YES" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc -x ntpdate_flags ntpdate_hosts > "/dev/null" 2>&1 || true
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

sysrc -q virtual_oss_default_control_device 2> "/dev/null" || ${ELEVATE} sysrc virtual_oss_default_control_device="" > "/dev/null" 2>&1 || true

for _devd_dir in "/etc/devd" "/usr/local/etc/devd"; do
	if [ -d "${_devd_dir}" ]; then
		for _devd_file in "${_devd_dir}"/*.conf; do
			if [ -f "${_devd_file}" ] && grep -Eq "virtual_oss_cmd|virtual_oss_default_control_device" "${_devd_file}" 2> "/dev/null"; then
				${ELEVATE} sed -i '' -e ':a' -e '/\\$/N; s/\\\n[[:space:]]*/ /; ta' "${_devd_file}" 2> "/dev/null" || true
				${ELEVATE} sed -i '' -E 's|(/usr/sbin/)?virtual_oss_cmd[[:space:]]*/dev/\$\(sysrc[[:space:]]+(-[a-zA-Z]*n[a-zA-Z]*[[:space:]]+)?virtual_oss_default_control_device\)|ctl=\$(sysrc -qn virtual_oss_default_control_device 2>/dev/null \|\| true); [ -n "\${ctl}" ] \&\& [ -e "/dev/\${ctl}" ] \&\& \1virtual_oss_cmd /dev/\${ctl}|g' "${_devd_file}" 2> "/dev/null" || true
			fi
		done
	fi
done

for _mixer_state in /var/db/mixer*-state; do
	if [ -f "${_mixer_state}" ]; then
		${ELEVATE} sed -i '' '/^mic\.volume=/d' "${_mixer_state}" 2> "/dev/null" || true
	fi
done

for _sc in "kern.coredump=0" "kern.vt.enable_bell=0"; do
	${ELEVATE} sysctl "${_sc}" > "/dev/null" 2>&1 || true
	grep -qxF "${_sc}" "/etc/sysctl.conf" 2> "/dev/null" || echo "${_sc}" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
done

${ELEVATE} sysctl hw.snd.default_unit=1 > "/dev/null" 2>&1 || true
if sysctl dev.pcm.2 > "/dev/null" 2>&1; then
	${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true
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
		graphics/drm-66-kmod graphics/gpu-firmware-intel-kmod-alderlake \
		multimedia/libva-intel-media-driver multimedia/libva-utils 2> "/dev/null" || true
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
	if grep -q "^[[:space:]]*$1=" "/boot/loader.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' "s|^[[:space:]]*$1=.*|$1=\"$2\"|" "/boot/loader.conf" 2> "/dev/null" || true
	else
		echo "$1=\"$2\"" | ${ELEVATE} tee -a "/boot/loader.conf" > "/dev/null"
	fi
}

if [ -f "/boot/loader.conf" ]; then
	for _entry in \
		"compat.linuxkpi.i915_enable_psr=0" "compat.linuxkpi.i915_enable_psr2_sel_fetch=0" \
		"compat.linuxkpi.i915_enable_fbc=0" "compat.linuxkpi.i915_enable_dc=0" \
		"compat.linuxkpi.i915_enable_guc=2" "compat.linuxkpi.i915_disable_power_well=0" \
		"kern.ipc.shmseg=1024" "kern.ipc.shmmni=1024" "kern.maxproc=100000" \
		"compat.linuxkpi.skb.mem_limit=1" "compat.linuxkpi.rtw88_disable_lps_deep=1" \
		"compat.linuxkpi.rtw88_pci_disable_aspm=1" "hw.pci.enable_aspm=0"; do
		_set_loader_tunable "${_entry%%=*}" "${_entry#*=}"
	done
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
start_cmd="[ -x /usr/local/sbin/net-auto-switch ] && /usr/local/sbin/net-auto-switch auto"

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
