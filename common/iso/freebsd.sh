#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Download Dynamic Latest FreeBSD RELEASE ISO
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
			Uso: freebsd.sh [opções]

			Descobre e baixa dinamicamente a versão estável mais recente da ISO do FreeBSD.

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

_ui_step "Resolvendo a imagem ISO oficial mais recente do FreeBSD..."
_base_url="https://download.freebsd.org/releases/amd64/amd64"
_ver="$(curl -sL "${_base_url}/" 2> "/dev/null" | sed -n 's/.*href="\([0-9]\+\.[0-9]\+\)-RELEASE\/".*/\1/p' | sort -V | tail -n 1)"

if [ -z "${_ver}" ]; then
	_ui_err "Não foi possível resolver dinamicamente a versão estável do FreeBSD."
	exit 1
fi

_iso_name="FreeBSD-${_ver}-RELEASE-amd64-disc1.iso"
_xz_name="${_iso_name}.xz"
_iso_url="${_base_url}/ISO-IMAGES/${_ver}/${_xz_name}"
_checksum_url="${_base_url}/ISO-IMAGES/${_ver}/CHECKSUM.SHA256-FreeBSD-${_ver}-RELEASE-amd64"

_ui_sub "Versão detectada: FreeBSD ${_ver}-RELEASE"
_ui_sub "Arquivo remoto: ${_xz_name}"
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

_target_iso="${_dest_dir}/${_iso_name}"
_target_xz="${_dest_dir}/${_xz_name}"
_ui_info "Destino final da ISO: ${_target_iso}"

if [ "${_dry_run}" -eq 1 ]; then
	_ui_step "Modo [dry-run]: Validando existência remota dos artefatos..."
	if curl -sLI "${_iso_url}" | grep -qE "HTTP/[0-9.]+ (200|302)"; then
		_ui_ok "Link da imagem compactada (.xz) validado com sucesso!"
	else
		_ui_err "Falha ao validar a existência remota do arquivo .xz do FreeBSD."
		exit 1
	fi
	if curl -sLI "${_checksum_url}" | grep -qE "HTTP/[0-9.]+ (200|302)"; then
		_ui_ok "Arquivo canônico de checksum SHA256 validado com sucesso!"
	fi
	_ui_ok "Resolução dinâmica do FreeBSD concluída com sucesso (sem download realizado)."
	exit 0
fi

mkdir -p "${_dest_dir}"

if [ -f "${_target_iso}" ]; then
	_ui_warn "Imagem final ${_target_iso} já existe. Pulando download."
	exit 0
fi

_ui_step "Baixando ${_xz_name}..."
curl -fL -o "${_target_xz}" "${_iso_url}"

_ui_step "Validando soma criptográfica SHA256..."
_expected_sum="$(curl -sL "${_checksum_url}" 2> "/dev/null" | grep "${_xz_name}" | awk '{print $4}' || true)"

if [ -n "${_expected_sum}" ]; then
	if command -v sha256sum > "/dev/null" 2>&1; then
		echo "${_expected_sum}  ${_target_xz}" | sha256sum -c - > "/dev/null" 2>&1 || {
			_ui_err "Falha na verificação de integridade SHA256!"
			exit 1
		}
		_ui_ok "Soma SHA256 do arquivo compactado validada com sucesso!"
	elif command -v sha256 > "/dev/null" 2>&1; then
		_calc="$(sha256 -q "${_target_xz}" 2> "/dev/null" || true)"
		if [ "${_calc}" = "${_expected_sum}" ]; then
			_ui_ok "Soma SHA256 do arquivo compactado validada com sucesso!"
		else
			_ui_err "Falha na verificação de integridade SHA256!"
			exit 1
		fi
	fi
fi

_ui_step "Descomprimindo imagem ISO (${_xz_name})..."
if command -v unxz > "/dev/null" 2>&1; then
	unxz -f "${_target_xz}"
	_ui_ok "Imagem descomprimida com sucesso: ${_target_iso}"
elif command -v xz > "/dev/null" 2>&1; then
	xz -d -f "${_target_xz}"
	_ui_ok "Imagem descomprimida com sucesso: ${_target_iso}"
else
	_ui_warn "Utilitário unxz não encontrado; arquivo mantido como ${_target_xz}."
fi

_ui_ok "ISO do FreeBSD pronta para uso!"
