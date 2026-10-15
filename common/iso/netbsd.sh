#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Download Dynamic Latest NetBSD Release ISO
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"

_dry_run=0
_dest_dir=""
_force_local=0

while [ "$#" -gt 0 ]; do
	case "$1" in
		-n|--dry-run)   _dry_run=1; shift ;;
		-l|--local)     _force_local=1; shift ;;
		-d|--datastore|--vm) _force_local=0; shift ;;
		-o|--output)
			[ "$#" -ge 2 ] || { _ui_err "Opção -o requer um diretório."; exit 1; }
			_dest_dir="$2"; shift 2 ;;
		-h|--help)
			cat <<- EOF
			Uso: netbsd.sh [opções]

			Descobre e baixa dinamicamente a versão estável mais recente da ISO do NetBSD.

			Opções:
			  -n, --dry-run      Apenas resolve a versão, valida o link e exibe detalhes
			  -l, --local        Salva no diretório atual (ideal para pendrives e mídia física)
			  -d, --datastore    Salva no datastore do hypervisor (/zroot/vm/.iso ou /var/lib/libvirt)
			  -o, --output DIR   Define um diretório de destino customizado
			  -h, --help         Exibe esta ajuda
			EOF
			exit 0
			;;
		*) _ui_err "Opção desconhecida: $1"; exit 1 ;;
	esac
done

_ui_step "Resolvendo a versão estável mais recente do NetBSD..."
_mirror="https://cdn.netbsd.org/pub/NetBSD"
_release="$(curl -sL "${_mirror}/" 2> "/dev/null" | grep -oE 'NetBSD-[0-9.]+' | sort -V -r | head -n 1)"

if [ -z "${_release}" ]; then
	_ui_err "Não foi possível resolver a versão estável da ISO do NetBSD."
	exit 1
fi

_iso_file="${_release}-amd64.iso"
_iso_url="${_mirror}/${_release}/images/${_iso_file}"
_checksum_url="${_mirror}/${_release}/images/SHA512"

_ui_sub "Versão detectada: ${_release}"
_ui_sub "Arquivo remoto: ${_iso_file}"
_ui_sub "URL oficial: ${_iso_url}"

if [ -z "${_dest_dir}" ]; then
	if [ "${_force_local}" -eq 1 ]; then
		_dest_dir="${PWD}"
	elif [ -d "/zroot/vm/.iso" ]; then
		_dest_dir="/zroot/vm/.iso"
	elif [ -d "/var/lib/libvirt/images" ]; then
		_dest_dir="/var/lib/libvirt/images"
	else
		_dest_dir="${PWD}"
	fi
fi

_target_iso="${_dest_dir}/${_iso_file}"
_ui_info "Destino final da ISO: ${_target_iso}"

if [ "${_dry_run}" -eq 1 ]; then
	_ui_step "Modo [dry-run]: Validando existência remota dos artefatos..."
	if curl -sLI "${_iso_url}" | grep -qE "HTTP/[0-9.]+ (200|302)"; then
		_ui_ok "Link da imagem de instalação validado com sucesso!"
	else
		_ui_err "Falha ao validar a existência remota da ISO do NetBSD."
		exit 1
	fi
	if curl -sLI "${_checksum_url}" | grep -qE "HTTP/[0-9.]+ (200|302)"; then
		_ui_ok "Arquivo de checksum SHA512 validado com sucesso!"
	fi
	_ui_ok "Resolução dinâmica do NetBSD concluída com sucesso (sem download realizado)."
	exit 0
fi

mkdir -p "${_dest_dir}"

if [ -f "${_target_iso}" ]; then
	_ui_warn "Imagem ${_target_iso} já existe. Pulando download."
	exit 0
fi

_ui_step "Baixando ${_iso_file}..."
curl -fL -o "${_target_iso}" "${_iso_url}"

_ui_step "Validando soma criptográfica SHA512..."
_expected_sum="$(curl -sL "${_checksum_url}" 2> "/dev/null" | grep -F "(${_iso_file})" | awk '{print $NF}' || true)"

if [ -n "${_expected_sum}" ]; then
	if command -v sha512sum > "/dev/null" 2>&1; then
		echo "${_expected_sum}  ${_target_iso}" | sha512sum -c - > "/dev/null" 2>&1 || {
			_ui_err "Falha na verificação de integridade SHA512!"
			exit 1
		}
		_ui_ok "Soma SHA512 validada com sucesso!"
	elif command -v sha512 > "/dev/null" 2>&1; then
		_calc="$(sha512 -q "${_target_iso}" 2> "/dev/null" || true)"
		if [ "${_calc}" = "${_expected_sum}" ]; then
			_ui_ok "Soma SHA512 validada com sucesso!"
		else
			_ui_err "Falha na verificação de integridade SHA512!"
			exit 1
		fi
	fi
fi

_ui_ok "ISO do NetBSD pronta para uso em: ${_target_iso}"
