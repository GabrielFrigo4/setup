#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Oracle Venture Caddy Web Server & Reverse Proxy
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando servidor web Caddy..."

${ELEVATE} apt install --yes debian-keyring debian-archive-keyring apt-transport-https curl

if [ ! -f "/etc/apt/sources.list.d/caddy-stable.list" ]; then
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | ${ELEVATE} gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | ${ELEVATE} tee /etc/apt/sources.list.d/caddy-stable.list > "/dev/null"
	${ELEVATE} apt update
fi

${ELEVATE} apt install --yes caddy

cat << 'EOF' | ${ELEVATE} tee "/etc/caddy/Caddyfile" > "/dev/null"
orbs.gabrielfrigo.dev.br, shop.gabrielfrigo.dev.br {
	reverse_proxy [::1]:35440
}
EOF

${ELEVATE} systemctl restart caddy

_ui_ok "Caddy configurado e ativo!"
