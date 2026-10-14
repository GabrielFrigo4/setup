#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Jails Subsystem
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Ativando subsistema nativo de Jails..."

${ELEVATE} sysrc jail_enable="YES"
${ELEVATE} mkdir -p "/usr/jails"

_ui_ok "Subsistema de Jails ativo no rc.conf!"
