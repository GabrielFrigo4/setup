#!/usr/bin/env sh
# ----------------------------------------------------------------
# Utility: Dynamic Official OS ISO Downloader & Verifier
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"

_dry_run=0; _dest_dir=""; _force_local=0; _target=""

_usage() {
	cat <<- EOF
		Uso: download.sh [-n|--dry-run] [-l|--local] [-d|--datastore] [-o DIR] <sistema|list>
		Sistemas: alpine, arch, debian, devuan, dragonfly, fedora, freebsd, netbsd, openbsd, void
	EOF
}

while [ "$#" -gt 0 ]; do
	case "$1" in
		-n|--dry-run)        _dry_run=1; shift ;;
		-l|--local)          _force_local=1; shift ;;
		-d|--datastore|--vm) _force_local=0; shift ;;
		-o|--output)         [ "$#" -ge 2 ] || { _ui_err "Opção -o requer diretório."; exit 1; }; _dest_dir="$2"; shift 2 ;;
		-h|--help)           _usage; exit 0 ;;
		list)                printf "alpine\narch\ndebian\ndevuan\ndragonfly\nfedora\nfreebsd\nnetbsd\nopenbsd\nvoid\n"; exit 0 ;;
		-*)                  _ui_err "Opção desconhecida: $1"; exit 1 ;;
		*)                   _target="$1"; shift ;;
	esac
done

[ -n "${_target}" ] || { _usage; exit 1; }
_fetch() { curl -sL "$1" 2> "/dev/null" | grep -oE "$2" | head -n 1 || true; }

_resolve_iso() {
	_dl=""; _iso_url=""; _chk_url=""; _alg="sha256"; _chk_mode="bsd"
	case "$1" in
		alpine)
			_m="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64"
			_dl="$(_fetch "${_m}/" 'alpine-virt-[0-9.]+-x86_64\.iso')"
			_iso_url="${_m}/${_dl}"; _chk_url="${_iso_url}.sha256"; _chk_mode="col1" ;;
		arch)
			_m="https://geo.mirror.pkgbuild.com/iso/latest"
			_dl="$(_fetch "${_m}/" 'archlinux-[0-9.]+-x86_64\.iso')"
			_iso_url="${_m}/${_dl}"; _chk_url="${_m}/sha256sums.txt"; _chk_mode="col1" ;;
		debian)
			_m="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd"
			_dl="$(_fetch "${_m}/" 'debian-[0-9.]+-amd64-netinst\.iso')"
			_iso_url="${_m}/${_dl}"; _chk_url="${_m}/SHA256SUMS"; _chk_mode="col1" ;;
		devuan)
			_m="https://files.devuan.org/devuan_daedalus/installer-iso"
			_dl="$(_fetch "${_m}/" 'devuan_daedalus_[0-9.]+_amd64_netinstall\.iso')"
			_iso_url="${_m}/${_dl}"; _chk_url="${_m}/SHA256SUMS.txt"; _chk_mode="col1" ;;
		dragonfly)
			_m="https://mirror-master.dragonflybsd.org/iso-images"
			_dl="$(curl -sL "${_m}/" 2> "/dev/null" | grep -oE 'dfly-x86_64-[0-9.]+_REL\.iso' | sort -V -r | head -n 1 || true)"
			_iso_url="${_m}/${_dl}"; _chk_url="${_m}/md5.txt"; _alg="md5" ;;
		fedora)
			_p="https://fedoraproject.org/server/download"
			_iso_url="$(_fetch "${_p}" 'https://[^"]*Fedora-Server-netinst-x86_64-[^"]*\.iso')"
			_dl="${_iso_url##*/}"; _chk_url="$(_fetch "${_p}" 'https://[^"]*Server-.*-x86_64-CHECKSUM')" ;;
		freebsd)
			_m="https://download.freebsd.org/releases/amd64/amd64"
			_v="$(curl -sL "${_m}/" 2> "/dev/null" | sed -n 's/.*href="\([0-9]\+\.[0-9]\+\)-RELEASE\/".*/\1/p' | sort -V | tail -n 1 || true)"
			[ -n "${_v}" ] && _dl="FreeBSD-${_v}-RELEASE-amd64-disc1.iso.xz"
			_iso_url="${_m}/ISO-IMAGES/${_v}/${_dl}"; _chk_url="${_m}/ISO-IMAGES/${_v}/CHECKSUM.SHA256-FreeBSD-${_v}-RELEASE-amd64" ;;
		netbsd)
			_m="https://cdn.netbsd.org/pub/NetBSD"
			_v="$(curl -sL "${_m}/" 2> "/dev/null" | grep -oE 'NetBSD-[0-9.]+' | sort -V -r | head -n 1 || true)"
			[ -n "${_v}" ] && _dl="${_v}-amd64.iso"
			_iso_url="${_m}/${_v}/images/${_dl}"; _chk_url="${_m}/${_v}/images/SHA512"; _alg="sha512" ;;
		openbsd)
			_m="https://cdn.openbsd.org/pub/OpenBSD"
			for _c in $(curl -sL "${_m}/" 2> "/dev/null" | grep -oE '[0-9]+\.[0-9]+' | sort -V -r | uniq); do
				_chk="$(_fetch "${_m}/${_c}/amd64/" 'install[0-9]+\.iso')"
				if [ -n "${_chk}" ]; then _v="${_c}"; _dl="${_chk}"; break; fi
			done
			_iso_url="${_m}/${_v:-}/amd64/${_dl}"; _chk_url="${_m}/${_v:-}/amd64/SHA256" ;;
		void)
			_m="https://repo-default.voidlinux.org/live/current"
			_dl="$(_fetch "${_m}/" 'void-live-x86_64-[0-9]+-base\.iso')"
			_iso_url="${_m}/${_dl}"; _chk_url="${_m}/sha256sum.txt" ;;
		*) _ui_err "Sistema desconhecido: $1 (use 'list')."; exit 1 ;;
	esac
}

_ui_step "Resolvendo imagem ISO oficial para '${_target}'..."
_resolve_iso "${_target}"
[ -n "${_dl}" ] && [ -n "${_iso_url}" ] || { _ui_err "Falha ao resolver ISO para ${_target}."; exit 1; }
_ui_sub "Arquivo: ${_dl} (${_iso_url})"

if [ -z "${_dest_dir}" ]; then
	if [ "${_force_local}" -eq 1 ]; then _dest_dir="${PWD}"
	elif [ -d "/zroot/vm/.iso" ]; then _dest_dir="/zroot/vm/.iso"
	elif [ -d "/var/lib/libvirt/images" ]; then _dest_dir="/var/lib/libvirt/images"
	else _dest_dir="${PWD}"; fi
fi

_dl_path="${_dest_dir}/${_dl}"; _final_path="${_dest_dir}/${_dl%.xz}"
if [ "${_dry_run}" -eq 1 ]; then
	curl -sLI "${_iso_url}" | grep -qE "HTTP/[0-9.]+ (200|302)" || { _ui_err "URL da ISO inacessível."; exit 1; }
	_ui_ok "Dry-run validado com sucesso: ${_final_path}"; exit 0
fi
mkdir -p "${_dest_dir}"
[ -f "${_final_path}" ] && { _ui_warn "Imagem ${_final_path} já existe."; exit 0; }
_ui_step "Baixando ${_dl}..."
curl -fL -o "${_dl_path}" "${_iso_url}"
if [ -n "${_chk_url}" ]; then
	if [ "${_chk_mode}" = "bsd" ]; then _sum="$(curl -sL "${_chk_url}" 2> "/dev/null" | grep -F "(${_dl})" | awk '{print $NF}' | tr -d ' \r\n' || true)"
	else _sum="$(curl -sL "${_chk_url}" 2> "/dev/null" | grep -F "${_dl}" | awk '{print $1}' | tr -d ' \r\n' || true)"; fi
	if [ -n "${_sum}" ]; then
		if command -v "${_alg}sum" > "/dev/null" 2>&1; then echo "${_sum}  ${_dl_path}" | "${_alg}sum" -c - > "/dev/null" 2>&1 || { _ui_err "Checksum ${_alg} inválido!"; exit 1; }
		elif command -v "${_alg}" > "/dev/null" 2>&1; then [ "$("${_alg}" -q "${_dl_path}" 2> "/dev/null" || true)" = "${_sum}" ] || { _ui_err "Checksum ${_alg} inválido!"; exit 1; }; fi
		_ui_ok "Checksum ${_alg} validado!"
	fi
fi
case "${_dl}" in
	*.xz)
		if command -v unxz > "/dev/null" 2>&1; then unxz -f "${_dl_path}"
		elif command -v xz > "/dev/null" 2>&1; then xz -d -f "${_dl_path}"
		else _ui_warn "unxz/xz ausente; mantido ${_dl_path}"; fi ;;
esac
_ui_ok "ISO pronta em: ${_final_path}"
