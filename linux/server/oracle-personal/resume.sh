#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Oracle Personal Resume Service
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando serviço Resume..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
USER_HOME="$(eval echo "~${TARGET_USER}")"

mkdir -p "${USER_HOME}/resume"

cat << EOF | ${ELEVATE} tee "/etc/systemd/system/resume.service" > "/dev/null"
[Unit]
Description=Gabriel Frigo - Resume
After=network.target

[Service]
User=${TARGET_USER}
Group=${TARGET_USER}
WorkingDirectory=${USER_HOME}/resume/
ExecStart=${USER_HOME}/resume/resume
Restart=always

[Install]
WantedBy=multi-user.target
EOF

${ELEVATE} systemctl daemon-reload
${ELEVATE} systemctl enable --now resume 2> "/dev/null" || true

_ui_ok "Serviço Resume configurado!"
