#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Oracle Orbs Catalogo Service
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Orbs Server]: Configurando serviço Catalogo..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
USER_HOME="$(eval echo "~${TARGET_USER}")"

podman network exists "rede-catalogo" 2> "/dev/null" || podman network create --ipv6 "rede-catalogo" > "/dev/null" 2>&1 || true

mkdir -p "${USER_HOME}/catalogo/pb_data"

cat << EOF | ${ELEVATE} tee "/etc/systemd/system/catalogo.service" > "/dev/null"
[Unit]
Description=Orbs Tech Solution - Catalogo Container
After=network.target

[Service]
User=${TARGET_USER}
Group=${TARGET_USER}
WorkingDirectory=${USER_HOME}/catalogo/
Environment="XDG_RUNTIME_DIR=/run/user/1000"

ExecStartPre=-/usr/bin/podman rm -f container-catalogo
ExecStartPre=-/usr/bin/podman load -i ${USER_HOME}/catalogo/image-catalogo.tar
ExecStart=/usr/bin/podman run --name container-catalogo \\
    -p "[::]:35440:35440" \\
    --network rede-catalogo \\
    -v "${USER_HOME}/catalogo/pb_data:/app/pb_data" \\
    localhost/image-catalogo:latest

ExecStop=/usr/bin/podman stop container-catalogo
ExecStopPost=-/usr/bin/podman rm -f container-catalogo

Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

${ELEVATE} systemctl daemon-reload
${ELEVATE} systemctl enable --now catalogo 2> "/dev/null" || true

echo "✅ [Orbs Server]: Serviço Catalogo configurado!"
