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
	git -C "${_build_dir}" checkout -- . 2> "/dev/null" || true
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
	_cargo_extra=""
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

		### --------------------------------
		### drm-rs FreeBSD Node Type Patch
		### --------------------------------
		# devfs assigns arbitrary minors, so drm-rs misclassifies /dev/dri/card0
		# as a Control node and EWM skips it (0 outputs). Derive the type from
		# the devname suffix (drm/0, dri/renderD128) instead of minor(dev).
		cargo fetch
		_drm_ver="$(awk '/^name = "drm"$/ { getline; gsub(/[^0-9.]/, ""); print; exit }' Cargo.lock 2> "/dev/null" || true)"
		_drm_src="$(find "${CARGO_HOME:-${HOME}/.cargo}/registry/src" -maxdepth 2 -type d -name "drm-${_drm_ver}" 2> "/dev/null" | head -n 1)"
		_drm_patched="${_build_dir}/patches/drm"
		if [ -n "${_drm_ver}" ] && [ -f "${_drm_src}/src/node/mod.rs" ]; then
			rm -rf "${_drm_patched}"
			mkdir -p "${_build_dir}/patches"
			cp -R "${_drm_src}" "${_drm_patched}"
			chmod -R u+w "${_drm_patched}"
			_node_rs="${_drm_patched}/src/node/mod.rs"
			sed -i '' \
				-e 's|^        let ty = match minor(dev) >> 6 {|        #[cfg(target_os = "freebsd")]\
        let minor_id = devname(dev)\
            .and_then(\|n\| n.trim_start_matches(\|c: char\| !c.is_numeric()).parse::<u32>().ok())\
            .ok_or(CreateDrmNodeError::NotDrmNode)?;\
        #[cfg(not(target_os = "freebsd"))]\
        let minor_id = minor(dev);\
        let ty = match minor_id >> 6 {|' \
				-e 's|let id = old_id & id_mask + ty.minor_base();|let id = (old_id \& id_mask) + ty.minor_base();|' \
				"${_node_rs}"
			if grep -q "let minor_id = devname(dev)" "${_node_rs}"; then
				_cargo_extra="patch.crates-io.drm.path=\"${_drm_patched}\""
				_ui_ok "drm-rs ${_drm_ver} corrigido para detecção de nós DRM no FreeBSD."
			else
				_ui_warn "Patch FreeBSD do drm-rs ${_drm_ver} não aplicado (layout upstream mudou)."
			fi
		else
			_ui_warn "Fonte do crate drm não localizada; EWM pode não detectar outputs DRM no FreeBSD."
		fi
	fi
	if [ -n "${_cargo_extra}" ]; then
		cargo build --release --config "${_cargo_extra}"
	else
		cargo build --release
	fi
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
