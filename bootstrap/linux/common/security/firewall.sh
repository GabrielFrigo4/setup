#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Linux Universal Firewall Setup (Ports 22, 80, 443)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Linux Firewall]: Configurando regras de firewall para portas 22, 80 e 443..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

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

echo "✅ [Linux Firewall]: Regras de firewall aplicadas com sucesso!"
