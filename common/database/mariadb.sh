#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: MariaDB Relational Database Server & Client
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v mariadb > "/dev/null" 2>&1; then
	_ui_ok "MariaDB já está instalado."
	exit 0
fi

_ui_step "Instalando MariaDB..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		databases/mariadb114-server \
		databases/mariadb114-client
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		mariadb-server \
		mariadb
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		mariadb-server \
		mariadb-client
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libmariadbclient
	else
		${ELEVATE} pacman -S --needed --noconfirm mariadb
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install mariadb
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install mariadb
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id MariaDB.Server --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "MariaDB instalado com sucesso!"
