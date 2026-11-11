#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: BastilleBSD Jail Automation Manager
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando gerenciador BastilleBSD..."

${ELEVATE} pkg install -y sysutils/bastille
${ELEVATE} sysrc bastille_enable="YES"
${ELEVATE} sysrc cloned_interfaces+="lo1" > "/dev/null" 2>&1 || true
${ELEVATE} sysrc ifconfig_lo1_name="bastille0" > "/dev/null" 2>&1 || true
${ELEVATE} service bastille start 2> "/dev/null" || true

_ui_ok "Gerenciador BastilleBSD pronto para uso!"
