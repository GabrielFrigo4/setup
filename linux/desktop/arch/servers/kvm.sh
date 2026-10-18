#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Server Keys & Hypervisor Integration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando permissões seguras e ambiente de virtualização KVM..."

if [ -n "${PERSONAL_SERVER_KEY-}" ] && [ -f "${PERSONAL_SERVER_KEY}" ]; then
	chmod 0600 "${PERSONAL_SERVER_KEY}"
	_ui_ok "Permissões de PERSONAL_SERVER_KEY ajustadas para 0600."
fi

if [ -n "${VENTURE_SERVER_KEY-}" ] && [ -f "${VENTURE_SERVER_KEY}" ]; then
	chmod 0600 "${VENTURE_SERVER_KEY}"
	_ui_ok "Permissões de VENTURE_SERVER_KEY ajustadas para 0600."
fi

# Clean-break: expurgo de shims e wrappers legados de /usr/local/bin
_legacy_purged=0
for _shim in freebsd-start freebsd-close freebsd-restart freebsd-server; do
	if [ -f "/usr/local/bin/${_shim}" ]; then
		${ELEVATE} rm -f "/usr/local/bin/${_shim}" 2> "/dev/null" || true
		_legacy_purged=$(( _legacy_purged + 1 ))
	fi
done
if [ "${_legacy_purged}" -gt 0 ]; then
	_ui_ok "Expurgados ${_legacy_purged} scripts legados de /usr/local/bin (orquestração migrada para o Universal Shell)."
fi

_ui_ok "Ambiente KVM pronto! Controle de VMs e containers centralizado no Universal Shell (fb, ob, nt, lx)."
