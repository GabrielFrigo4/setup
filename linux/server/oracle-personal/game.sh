#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Oracle Personal Game Service
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando serviço Game..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
USER_HOME="$(eval echo "~${TARGET_USER}")"

mkdir -p "${USER_HOME}/game"

if [ ! -f "${USER_HOME}/game/.env" ]; then
	cat <<- EOF > "${USER_HOME}/game/.env"
	ADMIN_USER="${GAME_ADMIN_USER:-admin}"
	ADMIN_PASS="${GAME_ADMIN_PASS:-change_me}"
	EOF
	chmod 0600 "${USER_HOME}/game/.env"
	_ui_info "Arquivo ${USER_HOME}/game/.env criado com modelo inicial (chmod 0600)."
	_ui_sub "Edite-o manualmente com as credenciais guardadas no seu Vault."
fi

cat << EOF | ${ELEVATE} tee "/etc/systemd/system/game.service" > "/dev/null"
[Unit]
Description=Gabriel Frigo - Game
After=network.target

[Service]
User=${TARGET_USER}
Group=${TARGET_USER}
WorkingDirectory=${USER_HOME}/game/
EnvironmentFile=${USER_HOME}/game/.env
ExecStart=${USER_HOME}/game/game
Restart=always

[Install]
WantedBy=multi-user.target
EOF

${ELEVATE} systemctl daemon-reload
${ELEVATE} systemctl enable --now game 2> "/dev/null" || true

_ui_ok "Serviço Game configurado!"
