#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Bookokrat Terminal EPUB, PDF & DjVu Reader
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v bookokrat > "/dev/null" 2>&1; then
	_ui_ok "Bookokrat já instalado."
	exit 0
fi

_ui_step "Instalando Bookokrat (leitor TUI de PDF, EPUB e DjVu)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes textproc/bookokrat
elif command -v curl > "/dev/null" 2>&1 && command -v tar > "/dev/null" 2>&1; then
	_version="v0.3.13"
	_arch="$(uname -m)"
	case "${_arch}" in
		x86_64|amd64) _target="x86_64-unknown-linux-musl" ;;
		aarch64|arm64) _target="aarch64-unknown-linux-musl" ;;
		*) _target="" ;;
	esac

	if [ -n "${_target}" ]; then
		_tmp="$(mktemp -d)"
		_url="https://github.com/bugzmanov/bookokrat/releases/download/${_version}/bookokrat-${_version}-${_target}.tar.gz"
		if curl -fsSL -o "${_tmp}/bookokrat.tar.gz" "${_url}"; then
			tar -xzf "${_tmp}/bookokrat.tar.gz" -C "${_tmp}"
			${ELEVATE} install -m 0755 "${_tmp}/bookokrat" "/usr/local/bin/bookokrat"
			rm -rf "${_tmp}"
		fi
	fi
fi

if ! command -v bookokrat > "/dev/null" 2>&1 && command -v cargo > "/dev/null" 2>&1; then
	cargo install bookokrat
fi

if command -v bookokrat > "/dev/null" 2>&1; then
	_ui_ok "Bookokrat instalado com sucesso!"
else
	_ui_warn "Não foi possível instalar o Bookokrat automaticamente."
fi
