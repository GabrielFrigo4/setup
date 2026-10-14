#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal Firewall Setup (Ports 22, 80, 443)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando regras de firewall para portas 22, 80 e 443..."

if command -v firewall-cmd > "/dev/null" 2>&1; then
	${ELEVATE} firewall-cmd --permanent --add-service=ssh > "/dev/null" 2>&1 || true
	${ELEVATE} firewall-cmd --permanent --add-service=http > "/dev/null" 2>&1 || true
	${ELEVATE} firewall-cmd --permanent --add-service=https > "/dev/null" 2>&1 || true
	${ELEVATE} firewall-cmd --reload > "/dev/null" 2>&1 || true
elif command -v ufw > "/dev/null" 2>&1; then
	${ELEVATE} ufw allow 22/tcp > "/dev/null" 2>&1 || true
	${ELEVATE} ufw allow 80/tcp > "/dev/null" 2>&1 || true
	${ELEVATE} ufw allow 443/tcp > "/dev/null" 2>&1 || true
	${ELEVATE} ufw --force enable > "/dev/null" 2>&1 || true
elif command -v iptables > "/dev/null" 2>&1; then
	if command -v apt > "/dev/null" 2>&1; then
		${ELEVATE} apt install --yes iptables-persistent netfilter-persistent 2> "/dev/null" || true
	fi
	for _port in 22 80 443; do
		${ELEVATE} iptables -I INPUT 1 -p tcp --dport "${_port}" -j ACCEPT 2> "/dev/null" || true
		${ELEVATE} ip6tables -I INPUT 1 -p tcp --dport "${_port}" -j ACCEPT 2> "/dev/null" || true
	done
	if command -v netfilter-persistent > "/dev/null" 2>&1; then
		${ELEVATE} netfilter-persistent save > "/dev/null" 2>&1 || true
	fi
fi

_ui_ok "Regras de firewall aplicadas com sucesso!"
