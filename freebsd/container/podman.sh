#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Podman Container Engine
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando Podman nativo no FreeBSD..."

${ELEVATE} pkg install --yes sysutils/podman

_ui_ok "Engine Podman nativa instalada com sucesso!"
