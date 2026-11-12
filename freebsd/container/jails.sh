#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Native Jails Subsystem
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando subsistema nativo de Jails..."

${ELEVATE} mkdir -p "/usr/jails"

if [ ! -f "/etc/jail.conf" ]; then
	${ELEVATE} touch "/etc/jail.conf"
	${ELEVATE} chmod 0644 "/etc/jail.conf"
fi

_has_configured_jails=0
if grep -q "{" "/etc/jail.conf" 2> "/dev/null"; then
	_has_configured_jails=1
elif [ -d "/etc/jail.conf.d" ]; then
	_conf_count="$(find /etc/jail.conf.d -mindepth 1 -maxdepth 1 -name "*.conf" 2> "/dev/null" | wc -l)"
	[ "${_conf_count}" -gt 0 ] && _has_configured_jails=1
fi

if [ "${_has_configured_jails}" -eq 1 ]; then
	${ELEVATE} sysrc jail_enable="YES" > "/dev/null" 2>&1 || true
	_ui_ok "Subsistema de Jails ativo com jails configuradas!"
else
	[ "$(sysrc -n jail_enable 2> "/dev/null" || true)" = "YES" ] && ${ELEVATE} sysrc jail_enable="NO" > "/dev/null" 2>&1 || true
	_ui_ok "Estrutura base de Jails provisionada com segurança!"
fi
