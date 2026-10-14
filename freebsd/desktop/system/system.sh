#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Base System Setup
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Iniciando configuração base do FreeBSD..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} pw groupmod wheel -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod operator -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod video -m "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} pw groupmod webcamd -m "${TARGET_USER}" 2> "/dev/null" || true

${ELEVATE} pkg bootstrap --yes
${ELEVATE} pkg update

${ELEVATE} sysrc allscreens_flags="-f spleen-16x32"

### --------------------------------
### Audio OSS and Sndiod Tuning
### --------------------------------
${ELEVATE} pkg install --yes audio/sndiod 2> "/dev/null" || true
${ELEVATE} sysrc sndiod_enable="YES" > "/dev/null" 2>&1 || true

${ELEVATE} sysctl kern.coredump=0 > "/dev/null" 2>&1 || true
grep -qxF "kern.coredump=0" "/etc/sysctl.conf" 2> "/dev/null" || echo "kern.coredump=0" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"

${ELEVATE} sysctl hw.snd.default_unit=2 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_0.val=0 > "/dev/null" 2>&1 || true
${ELEVATE} sysctl dev.pcm.2.mixer.vol_0_1.val=0 > "/dev/null" 2>&1 || true

if ! grep -q "hw.snd.default_unit=2" "/etc/sysctl.conf" 2> "/dev/null"; then
	cat <<- "EOF" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
	# Default USB Audio
	hw.snd.default_unit=2
	dev.pcm.2.mixer.vol_0_0.val=0
	dev.pcm.2.mixer.vol_0_1.val=0
	EOF
fi

### --------------------------------
### DRM and KMS Graphics Tuning
### --------------------------------
${ELEVATE} pkg install --yes graphics/drm-kmod 2> "/dev/null" || true
if ! sysrc -n kld_list 2> "/dev/null" | grep -q "i915kms"; then
	${ELEVATE} sysrc kld_list+="i915kms" > "/dev/null" 2>&1 || true
fi

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
	_set_loader_tunable "compat.linuxkpi.i915_enable_fbc" "0"
	_set_loader_tunable "compat.linuxkpi.i915_enable_dc" "0"
fi

### --------------------------------
### Wi-Fi Background Scan Fix
### --------------------------------
if [ -f "/etc/rc.conf" ]; then
	if grep -q "ifconfig_wlan0=" "/etc/rc.conf" 2> "/dev/null"; then
		if ! grep -q -- "-bgscan" "/etc/rc.conf" 2> "/dev/null"; then
			${ELEVATE} sysrc ifconfig_wlan0="WPA DHCP -bgscan" > "/dev/null" 2>&1 || true
		fi
	fi
	if grep -q "/boot/kernel/fusefs.ko" "/etc/rc.conf" 2> "/dev/null" && grep -q " fusefs" "/etc/rc.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i '' 's| fusefs||g' "/etc/rc.conf"
	fi
fi

mkdir -p "${HOME}/Workspace"

_ui_ok "Configuração base concluída com sucesso!"
