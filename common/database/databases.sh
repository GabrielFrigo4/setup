#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Database Engines Suite Orchestrator
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v sqlite3 > "/dev/null" 2>&1 && \
   command -v psql > "/dev/null" 2>&1 && \
   command -v mariadb > "/dev/null" 2>&1 && \
   command -v redis-cli > "/dev/null" 2>&1; then
	_ui_ok "Suíte principal de bancos de dados já instalada."
	exit 0
fi

_ui_step "Provisionando suíte universal de bancos de dados..."

_dir="$(cd "$(dirname "$0")" && pwd)"

for _recipe in sqlite.sh postgresql.sh mariadb.sh redis.sh duckdb.sh mongodb.sh; do
	if [ -f "${_dir}/${_recipe}" ]; then
		sh "${_dir}/${_recipe}"
	fi
done

_ui_ok "Suíte de bancos de dados provisionada com sucesso!"
