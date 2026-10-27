#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: MySQL Relational Database Server & Client
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v mysql > "/dev/null" 2>&1; then
	_ui_ok "Cliente/Servidor MySQL já disponível no PATH."
	exit 0
fi

_ui_step "Instalando MySQL..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		databases/mysql80-server \
		databases/mysql80-client
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		community-mysql-server \
		community-mysql
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		default-mysql-server \
		default-mysql-client
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libmariadbclient
	else
		${ELEVATE} pacman -S --needed --noconfirm mariadb-clients
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install mysql
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install mysql
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Oracle.MySQL --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "MySQL instalado com sucesso!"
