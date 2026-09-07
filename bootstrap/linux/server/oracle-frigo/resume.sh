#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Oracle Frigo Resume Service
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Frigo Server]: Configurando serviço Resume..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

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

echo "✅ [Frigo Server]: Serviço Resume configurado!"
