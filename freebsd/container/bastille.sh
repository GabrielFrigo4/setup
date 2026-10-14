#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: BastilleBSD Jail Automation Manager
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando gerenciador BastilleBSD..."

${ELEVATE} pkg install --yes sysutils/bastille
${ELEVATE} sysrc bastille_enable="YES"
${ELEVATE} service bastille start 2> "/dev/null" || true

_ui_ok "Gerenciador BastilleBSD pronto para uso!"
