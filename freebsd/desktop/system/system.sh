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

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} pw groupmod wheel -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod operator -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod video -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod webcamd -m "${TARGET_USER}" 2> "/dev/null" || true

command -v pkg > "/dev/null" 2>&1 || ${ELEVATE} pkg bootstrap -y
${ELEVATE} pkg update

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
[ "$(sysrc -n moused_flags 2> "/dev/null" || true)" != "-A 1.5,1.5 -a 1.2" ] && ${ELEVATE} sysrc moused_flags="-A 1.5,1.5 -a 1.2" > "/dev/null" 2>&1 || true
[ "$(sysrc -n keyrate 2> "/dev/null" || true)" != "fast" ] && ${ELEVATE} sysrc keyrate="fast" > "/dev/null" 2>&1 || true
if [ -x "/etc/rc.d/syscons" ]; then
	${ELEVATE} /etc/rc.d/syscons restart > "/dev/null" 2>&1 || true
fi
if command -v kbdcontrol > "/dev/null" 2>&1; then
	_esc=$'\e'
	${ELEVATE} kbdcontrol -f 65 "${_esc}[1;5D" > "/dev/null" 2>&1 || true
	${ELEVATE} kbdcontrol -f 66 "${_esc}[1;5C" > "/dev/null" 2>&1 || true
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

${ELEVATE} sysctl hw.snd.default_unit=2 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true

if ! grep -q "hw.snd.default_unit=2" "/etc/sysctl.conf" 2> "/dev/null"; then
	cat <<- "EOF" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
	hw.snd.default_unit=2
	dev.pcm.2.mixer.vol_0_0.val=0
	dev.pcm.2.mixer.vol_0_1.val=0
	EOF
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
		${ELEVATE} sed -i '' "s|^[[:space:]]*${_tunable}=.*|${_tunable}=\"${_value}\"|" "/boot/loader.conf"
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
fi

### --------------------------------
### ISOLAMENTO DE REDE E WI-FI
### --------------------------------
if [ -f "/etc/rc.conf" ]; then
	if grep -q "ifconfig_wlan0=" "/etc/rc.conf" 2> "/dev/null"; then
		${ELEVATE} sysrc ifconfig_wlan0="WPA DHCP -bgscan powersave" > "/dev/null" 2>&1 || true
	fi
	if grep -q "/boot/kernel/fusefs.ko" "/etc/rc.conf" 2> "/dev/null" && grep -q " fusefs" "/etc/rc.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' 's| fusefs||g' "/etc/rc.conf"
	fi
fi

_devd_dir="/usr/local/etc/devd"
[ -d "${_devd_dir}" ] || ${ELEVATE} mkdir -p "${_devd_dir}"
cat <<- "EOF" | ${ELEVATE} tee "${_devd_dir}/ethernet-wifi-isolation.conf" > "/dev/null"
notify 100 {
	match "system" "IFNET";
	match "type" "LINK_UP";
	media-type "ethernet";
	action "ifconfig wlan0 down > '/dev/null' 2>&1 || true";
};

notify 100 {
	match "system" "IFNET";
	match "type" "LINK_DOWN";
	media-type "ethernet";
	action "ifconfig wlan0 up > '/dev/null' 2>&1 || true";
};
EOF
${ELEVATE} chmod 0644 "${_devd_dir}/ethernet-wifi-isolation.conf"
if [ -x "/etc/rc.d/devd" ]; then
	${ELEVATE} /etc/rc.d/devd restart > "/dev/null" 2>&1 || true
fi

mkdir -p "${HOME}/Workspace"

_ui_ok "Configuração base concluída com sucesso!"
