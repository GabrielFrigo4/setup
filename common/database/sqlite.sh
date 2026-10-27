#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: SQLite Embedded Relational Database Engine
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v sqlite3 > "/dev/null" 2>&1; then
	_ui_ok "SQLite já está instalado."
	exit 0
fi

_ui_step "Instalando SQLite..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes databases/sqlite3
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes sqlite
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes sqlite3
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sqlite3
	else
		${ELEVATE} pacman -S --needed --noconfirm sqlite
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install sqlite
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install sqlite
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id SQLite.SQLite --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "SQLite instalado com sucesso!"
