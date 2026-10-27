#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: DuckDB In-Process Analytical OLAP SQL Database
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v duckdb > "/dev/null" 2>&1; then
	_ui_ok "DuckDB já está instalado."
	exit 0
fi

_ui_step "Instalando DuckDB..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes databases/duckdb 2> "/dev/null" || \
		_ui_info "DuckDB indisponível no espelho pkg atual."
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes duckdb 2> "/dev/null" || \
		_ui_info "DuckDB indisponível no espelho dnf atual."
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes duckdb 2> "/dev/null" || \
		_ui_info "DuckDB indisponível no espelho apt atual."
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM:-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-duckdb 2> "/dev/null" || true
	else
		${ELEVATE} pacman -S --needed --noconfirm duckdb
	fi
elif command -v brew > "/dev/null" 2>&1; then
	brew install duckdb
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install duckdb
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id DuckDB.cli --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Rotina do DuckDB concluída!"
