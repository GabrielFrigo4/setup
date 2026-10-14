#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Universal System & Kernel Tweaks
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Aplicando otimizações de kernel FreeBSD..."

${ELEVATE} sysctl kern.coredump=0 > "/dev/null" 2>&1 || true
if ! grep -q "kern.coredump=0" "/etc/sysctl.conf" 2> "/dev/null"; then
	echo "kern.coredump=0" | ${ELEVATE} tee -a "/etc/sysctl.conf" > "/dev/null"
fi

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

_ui_ok "Otimizações aplicadas com sucesso!"
