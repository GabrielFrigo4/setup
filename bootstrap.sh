#!/usr/bin/env sh
# ----------------------------------------------------------------
# Utility: Sovereign Setup Bootstrap Installer
# ----------------------------------------------------------------
set -eu

_repo="${SETUP_REPO:-https://github.com/GabrielFrigo4/setup.git}"
_branch="${SETUP_BRANCH:-main}"
_dir="${SETUP_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/setup}"

_elevate=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		_elevate="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		_elevate="sudo"
	fi
fi

if ! command -v git > "/dev/null" 2>&1; then
	echo "==> Instalando Git para clonar o repositório soberano..."
	if command -v pkg > "/dev/null" 2>&1; then
		${_elevate} pkg install --yes git
	elif command -v dnf > "/dev/null" 2>&1; then
		${_elevate} dnf install --assumeyes git
	elif command -v apt-get > "/dev/null" 2>&1; then
		${_elevate} apt-get update --quiet
		${_elevate} apt-get install --yes git
	elif command -v pacman > "/dev/null" 2>&1; then
		${_elevate} pacman -S --needed --noconfirm git
	else
		echo "❌ Erro: git não encontrado e gerenciador de pacotes indisponível." >&2
		exit 1
	fi
fi

if [ -d "${_dir}/.git" ]; then
	echo "==> Atualizando Setup soberano em: ${_dir}"
	git -C "${_dir}" pull --ff-only 2> "/dev/null" || git -C "${_dir}" pull --rebase 2> "/dev/null" || true
else
	echo "==> Clonando Setup soberano em: ${_dir}"
	mkdir -p "$(dirname "${_dir}")"
	git clone --branch "${_branch}" "${_repo}" "${_dir}"
fi

chmod 0755 "${_dir}/bootstrap.sh" "${_dir}/setup.sh" 2> "/dev/null" || true
if [ -f "${_dir}/core/perms.sh" ]; then
	. "${_dir}/core/perms.sh"
	_self_heal_perms "${_dir}"
fi

exec sh "${_dir}/setup.sh" "$@"
