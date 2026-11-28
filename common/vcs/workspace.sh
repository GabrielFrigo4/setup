#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Workspace & Hub Repositories Bootstrap
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"

WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/Workspace}"
_hub_repos="Environment:GabrielFrigo4/environment Foundation:GabrielFrigo4/foundation Personal:GabrielFrigo4/personal Research:GabrielFrigo4/research Training:GabrielFrigo4/training Venture:GabrielFrigo4/venture"

if ! command -v git > "/dev/null" 2>&1; then
	_ui_err "git não encontrado no PATH. Execute common/vcs/tools.sh primeiro."
	exit 1
fi

_ui_step "Preparando Workspace soberano em ${WORKSPACE_DIR}..."
mkdir -p "${WORKSPACE_DIR}"

_has_gh=0
if command -v gh > "/dev/null" 2>&1 && gh auth status > "/dev/null" 2>&1; then
	_has_gh=1
else
	_ui_warn "GitHub CLI (gh) não autenticado; utilizando fallback git clone."
fi

for _entry in ${_hub_repos}; do
	_name="${_entry%%:*}"
	_slug="${_entry##*:}"
	_dest="${WORKSPACE_DIR}/${_name}"

	if [ -d "${_dest}/.git" ]; then
		_ui_ok "${_name}: já clonado em ${_dest}"
	elif [ "${_has_gh}" -eq 1 ] && gh repo clone "${_slug}" "${_dest}"; then
		_ui_ok "${_name}: clonado via gh CLI"
	elif git clone "git@github.com:${_slug}.git" "${_dest}" 2> "/dev/null" || git clone "https://github.com/${_slug}.git" "${_dest}"; then
		_ui_ok "${_name}: clonado via git"
	else
		_ui_err "${_name}: falha ao clonar ${_slug}"
		exit 1
	fi

	if [ -f "${_dest}/Makefile" ] && grep -Eq '^[[:space:]]*clone:' "${_dest}/Makefile"; then
		if command -v make > "/dev/null" 2>&1; then
			_ui_sub "${_name}: inicializando submódulos/dependências (make clone)..."
			(cd "${_dest}" && make clone) || _ui_warn "${_name}: make clone retornou aviso."
		else
			_ui_warn "${_name}: make não encontrado; executando git submodule update..."
			git -C "${_dest}" submodule update --init --recursive || true
		fi
	fi
done

_ui_ok "Workspace e repositórios hub configurados em ${WORKSPACE_DIR}!"
