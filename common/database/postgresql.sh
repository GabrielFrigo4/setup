#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: PostgreSQL Relational Database Server & Client
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v psql > "/dev/null" 2>&1; then
	_ui_ok "PostgreSQL já está instalado."
	exit 0
fi

_ui_step "Instalando PostgreSQL..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		databases/postgresql16-server \
		databases/postgresql16-client
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		postgresql-server \
		postgresql
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		postgresql \
		postgresql-client
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-postgresql
	else
		${ELEVATE} pacman -S --needed --noconfirm postgresql
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install postgresql@16
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install postgresql
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id PostgreSQL.PostgreSQL --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "PostgreSQL instalado com sucesso!"
