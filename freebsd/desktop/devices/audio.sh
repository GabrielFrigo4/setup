#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Audio Routing to Android (RTP)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Iniciando configuração de áudio e roteamento..."

### --------------------------------
### 1. DEVD E VIRTUAL_OSS
### --------------------------------
sysrc -q virtual_oss_default_control_device 2> "/dev/null" || ${ELEVATE} sysrc virtual_oss_default_control_device="" > "/dev/null" 2>&1 || true

for _devd_dir in "/etc/devd" "/usr/local/etc/devd"; do
	if [ -d "${_devd_dir}" ]; then
		for _devd_file in "${_devd_dir}"/*.conf; do
			if [ -f "${_devd_file}" ] && grep -Eq "virtual_oss_cmd|virtual_oss_default_control_device" "${_devd_file}" 2> "/dev/null"; then
				_bak="$(mktemp "/tmp/devd.conf.XXXXXX")"
				cp "${_devd_file}" "${_bak}"
				${ELEVATE} sed -i '' -e ':a' -e '/\\$/N; s/\\\n[[:space:]]*/ /; ta' "${_devd_file}" 2> "/dev/null" || true
				${ELEVATE} sed -i '' -E \
					-e 's|ctl=\$\(sysrc[[:space:]]+-qn[[:space:]]+virtual_oss_default_control_device[^;]*;[[:space:]]*\[[[:space:]]*-n[[:space:]]+\\?"\$\{ctl\}\\?"[[:space:]]*\][[:space:]]*&&[[:space:]]*\[[[:space:]]*-e[[:space:]]+\\?"/dev/\$\{ctl\}\\?"[[:space:]]*\][[:space:]]*&&[[:space:]]*(/usr/sbin/)?virtual_oss_cmd[[:space:]]+/dev/\$\{ctl\}|ctl=$(sysrc -qn virtual_oss_default_control_device 2>'\''/dev/null'\''); [ -c /dev/${ctl:-nonexistent} ] \&\& /usr/sbin/virtual_oss_cmd /dev/${ctl}|g' \
					-e 's|(/usr/sbin/)?virtual_oss_cmd[[:space:]]+/dev/\$\(sysrc[[:space:]]+(-[a-zA-Z]*n[a-zA-Z]*[[:space:]]+)?virtual_oss_default_control_device\)|ctl=$(sysrc -qn virtual_oss_default_control_device 2>'\''/dev/null'\''); [ -c /dev/${ctl:-nonexistent} ] \&\& /usr/sbin/virtual_oss_cmd /dev/${ctl}|g' \
					"${_devd_file}" 2> "/dev/null" || true
				if command -v devd > "/dev/null" 2>&1 && command -v timeout > "/dev/null" 2>&1; then
					_st=0
					${ELEVATE} timeout 1 devd -d -f "${_devd_file}" > "/dev/null" 2>&1 || _st=$?
					if [ "${_st}" -ne 0 ] && [ "${_st}" -ne 124 ]; then
						${ELEVATE} cp "${_bak}" "${_devd_file}"
						${ELEVATE} chmod 0644 "${_devd_file}"
					fi
				fi
				rm -f "${_bak}"
			fi
		done
	fi
done

### --------------------------------
### 2. LIMPEZA DE ESTADO DO MIXER
### --------------------------------
${ELEVATE} sysrc mixer_enable="NO" > "/dev/null" 2>&1 || true

for _mixer_state in /var/db/mixer*-state; do
	[ -f "${_mixer_state}" ] && ${ELEVATE} sed -i '' '/^mic\.volume=/d' "${_mixer_state}" 2> "/dev/null" || true
done

### --------------------------------
### 3. ROTEAMENTO DE AUDIO RTP
### --------------------------------
if ! ifconfig ue0 > "/dev/null" 2>&1; then
	_ui_warn "Interface 'ue0' não encontrada. Conecte o dispositivo USB para roteamento de áudio."
	exit 0
fi

${ELEVATE} dhclient ue0 > "/dev/null" 2>&1 || true

PHONE_IP="$(grep 'dhcp-server-identifier' "/var/db/dhclient.leases.ue0" 2> "/dev/null" | tail -1 | awk '{print $3}' | tr -d ';')"

if [ -z "${PHONE_IP}" ]; then
	_ui_err "Não foi possível determinar o IP do celular."
	exit 1
fi

_ui_sub "Celular detectado em: ${PHONE_IP}"
pactl unload-module module-rtp-send > "/dev/null" 2>&1 || true
pactl load-module module-rtp-send source=oss_output.dsp0.monitor destination_ip="${PHONE_IP}" port=5004 > "/dev/null"

_ui_ok "Roteado! Abra o VLC no Android em 'rtp://@:5004'."
