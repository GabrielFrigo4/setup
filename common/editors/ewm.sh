#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: EWM (Emacs Wayland Manager) Rust Dynamic Module Build
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_common="${_setup_root}/common"
_target_lib="${HOME}/.local/lib/libewm_core.so"
_target_lisp="${HOME}/.local/share/emacs/site-lisp/ewm"

if ! command -v cargo > "/dev/null" 2>&1 || ! command -v rustc > "/dev/null" 2>&1 || ! pkg-config --exists libinput pixman-1 gbm wayland-server glib-2.0 libdisplay-info 2> "/dev/null"; then
	_ui_step "Instalando toolchain Rust e bibliotecas de compilação..."
	sh "${_common}/languages/rust-ewm.sh"
fi

_ui_step "Preparando repositório do EWM (Emacs Wayland Manager)..."

_build_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/ewm-build"
mkdir -p "${_build_dir}"

_ewm_repo="https://codeberg.org/ezemtsov/ewm.git"
_ewm_fallback="https://github.com/ezemtsov/ewm.git"

if [ -d "${_build_dir}/.git" ]; then
	git -C "${_build_dir}" pull --quiet 2> "/dev/null" || true
else
	git clone --depth 1 "${_ewm_repo}" "${_build_dir}" 2> "/dev/null" || \
		git clone --depth 1 "${_ewm_fallback}" "${_build_dir}"
fi

_ui_step "Compilando módulo nativo EWM via Cargo em modo release..."

_cargo_dir="${_build_dir}"
if [ -d "${_build_dir}/compositor" ] && [ -f "${_build_dir}/compositor/Cargo.toml" ]; then
	_cargo_dir="${_build_dir}/compositor"
fi

(
	cd "${_cargo_dir}"
	if [ "$(uname -s)" = "FreeBSD" ]; then
		_pc_override="${_build_dir}/pkgconfig-override"
		mkdir -p "${_pc_override}"
		cat << 'EOF' > "${_pc_override}/libdisplay-info.pc"
prefix=/usr/local
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: libdisplay-info
Description: EDID and DisplayID library
Version: 0.3.0
Libs: -L${libdir} -ldisplay-info
Cflags: -I${includedir}
EOF
		export PKG_CONFIG_PATH="${_pc_override}:/usr/local/libdata/pkgconfig:${PKG_CONFIG_PATH:-}"
	fi
	cargo build --release
)

_found_so="$(find "${_build_dir}/target/release" "${_cargo_dir}/target/release" -name "libewm_core.so" -o -name "libewm.so" 2> "/dev/null" | head -n 1)"

if [ -z "${_found_so}" ] || [ ! -f "${_found_so}" ]; then
	_ui_err "Falha na compilação: libewm_core.so não foi gerado."
	exit 1
fi

_ui_step "Instalando biblioteca compartilhada e arquivos Elisp..."

mkdir -p "${HOME}/.local/lib"
cp -f "${_found_so}" "${_target_lib}"
chmod 0755 "${_target_lib}"

mkdir -p "${_target_lisp}"
find "${_build_dir}" -name "*.el" -exec cp -f {} "${_target_lisp}/" \; 2> "/dev/null" || true

_ui_ok "EWM compilado e instalado com sucesso!"
_ui_info "Biblioteca: ${_target_lib}"
_ui_info "Lisp: ${_target_lisp}"
