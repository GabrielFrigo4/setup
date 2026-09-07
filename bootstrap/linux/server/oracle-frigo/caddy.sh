#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Oracle Frigo Caddy Web Server & Reverse Proxy
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Frigo Server]: Configurando servidor web Caddy..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} apt install --yes debian-keyring debian-archive-keyring apt-transport-https curl

if [ ! -f "/etc/apt/sources.list.d/caddy-stable.list" ]; then
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | ${ELEVATE} gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | ${ELEVATE} tee /etc/apt/sources.list.d/caddy-stable.list > "/dev/null"
	${ELEVATE} apt update
fi

${ELEVATE} apt install --yes caddy

cat << 'EOF' | ${ELEVATE} tee "/etc/caddy/Caddyfile" > "/dev/null"
gabrielfrigo.dev.br, www.gabrielfrigo.dev.br, resume.gabrielfrigo.dev.br {
	reverse_proxy [::1]:35440
}
game.gabrielfrigo.dev.br {
	reverse_proxy [::1]:35441
}
EOF

${ELEVATE} systemctl restart caddy

echo "✅ [Frigo Server]: Caddy configurado e ativo!"
