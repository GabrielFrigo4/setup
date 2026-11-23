#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Portable FreeBSD Desktop Base System Setup
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"
. "${_setup_root}/core/detect.sh"

_ui_step "Iniciando configuração base portátil do FreeBSD..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

for _grp in wheel operator video webcamd; do
	${ELEVATE} pw groupmod "${_grp}" -m "${TARGET_USER}" 2> "/dev/null" || true
done

command -v pkg > "/dev/null" 2>&1 || ${ELEVATE} pkg bootstrap -y

_target_font="${DETECTED_CONSOLE_FONT:-spleen-12x24}"
[ "$(sysrc -n allscreens_flags 2> "/dev/null" || true)" != "-f ${_target_font}" ] && ${ELEVATE} sysrc allscreens_flags="-f ${_target_font}" > "/dev/null" 2>&1 || true

_rcd_dir="/usr/local/etc/rc.d"
[ -d "${_rcd_dir}" ] || ${ELEVATE} mkdir -p "${_rcd_dir}"
${ELEVATE} cp "${_setup_root}/freebsd/desktop/system/vt-autofont.sh" "${_rcd_dir}/vt_autofont"
${ELEVATE} chmod 0755 "${_rcd_dir}/vt_autofont"

for _sr in \
	"vt_autofont_enable=YES" \
	"moused_enable=YES" \
	"moused_nondefault_enable=YES" \
	"moused_flags=-A 1.5,1.5 -a 1.2" \
	"keyrate=fast" \
	"background_dhclient=NO" \
	"defaultroute_delay=5" \
	"keymap=br.kbd" \
	"powerd_enable=YES" \
	"dumpdev=NO" \
	"dbus_enable=YES" \
	"devd_enable=YES" \
	"seatd_enable=YES" \
	"sddm_enable=NO" \
	"nfs_client_enable=YES" \
	"syslogd_flags=-ss"; do
	_k="${_sr%%=*}"
	_v="${_sr#*=}"
	[ "$(sysrc -n "${_k}" 2> "/dev/null" || true)" != "${_v}" ] && ${ELEVATE} sysrc "${_sr}" > "/dev/null" 2>&1 || true
done

for _ev in /dev/input/event*; do
	[ -c "${_ev}" ] && ${ELEVATE} service moused quietstart "${_ev#/dev/}" > "/dev/null" 2>&1 || true
done

if [ -f "/etc/fstab" ]; then
	grep -Eq "^[[:space:]]*fdesc[[:space:]]+/dev/fd" "/etc/fstab" 2> "/dev/null" || printf "fdesc\t\t/dev/fd\t\tfdescfs\trw\t\t0\t0\n" | ${ELEVATE} tee -a "/etc/fstab" > "/dev/null"
	grep -Eq "^[[:space:]]*proc[[:space:]]+/proc" "/etc/fstab" 2> "/dev/null" || printf "proc\t\t/proc\t\tprocfs\trw\t\t0\t0\n" | ${ELEVATE} tee -a "/etc/fstab" > "/dev/null"
fi

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
### AUDIO SNDIOD AND MIXER
### --------------------------------
pkg info -e sndiod > "/dev/null" 2>&1 || ${ELEVATE} pkg install --yes audio/sndiod 2> "/dev/null" || true
[ "$(sysrc -n sndiod_enable 2> "/dev/null" || true)" != "YES" ] && ${ELEVATE} sysrc sndiod_enable="YES" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc mixer_enable="NO" > "/dev/null" 2>&1 || true

for _mixer_state in /var/db/mixer*-state; do
	[ -f "${_mixer_state}" ] && ${ELEVATE} sed -i '' '/^mic\.volume=/d' "${_mixer_state}" 2> "/dev/null" || true
done

for _sc in "kern.coredump=0" "kern.vt.enable_bell=0"; do
	${ELEVATE} sysctl "${_sc}" > "/dev/null" 2>&1 || true
	grep -qxF "${_sc}" "/etc/sysctl.conf" 2> "/dev/null" || echo "${_sc}" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
done

mkdir -p "${HOME}/Workspace"

_ui_ok "Configuração base portátil concluída com sucesso!"
