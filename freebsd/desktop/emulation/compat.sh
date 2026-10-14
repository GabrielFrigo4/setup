#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Compat Layer (/compat/linux)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Ativando camada de compatibilidade Linux (/compat/linux)..."

${ELEVATE} sysrc linux_enable="YES"
${ELEVATE} service linux start 2> "/dev/null" || true

_ui_ok "Camada de compatibilidade (/compat/linux) ativa no kernel!"
