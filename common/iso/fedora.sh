#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Download Dynamic Latest Fedora Server Netinst ISO
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
			Uso: fedora.sh [opções]

			Descobre e baixa dinamicamente a versão estável mais recente da ISO Fedora Server Netinst (headless/server).

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

_ui_step "Resolvendo a imagem ISO estável mais recente do Fedora Server Netinst..."
_portal="https://fedoraproject.org/server/download"
_iso_url="$(curl -sL "${_portal}" 2> "/dev/null" | grep -oE 'https://[^"]*Fedora-Server-netinst-x86_64-[^"]*\.iso' | head -n 1)"

if [ -z "${_iso_url}" ]; then
	_ui_err "Não foi possível resolver dinamicamente o link da ISO no portal Fedora."
	exit 1
fi

_iso_file="${_iso_url##*/}"
_ui_sub "Versão detectada: ${_iso_file}"
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

_target_path="${_dest_dir}/${_iso_file}"
_ui_info "Destino: ${_target_path}"

if [ "${_dry_run}" -eq 1 ]; then
	_ui_step "Modo [dry-run]: Validando existência remota dos artefatos..."
	if curl -sLI "${_iso_url}" | grep -qE "HTTP/[0-9.]+ (200|302)"; then
		_ui_ok "Link da ISO validado com sucesso (HTTP 200/302)!"
	else
		_ui_err "Falha ao validar a existência remota da ISO Fedora Server."
		exit 1
	fi
	_ui_ok "Resolução dinâmica do Fedora Server concluída com sucesso (sem download realizado)."
	exit 0
fi

mkdir -p "${_dest_dir}"

if [ -f "${_target_path}" ]; then
	_ui_warn "Arquivo ${_target_path} já existe. Pulando download."
	exit 0
fi

_ui_step "Baixando ${_iso_file}..."
curl -fL -o "${_target_path}" "${_iso_url}"

_ui_step "Validando soma criptográfica SHA256..."
_chk_url="$(curl -sL "${_portal}" 2> "/dev/null" | grep -oE 'https://[^"]*Server-.*-x86_64-CHECKSUM' | head -n 1)"
_expected_sum=""
if [ -n "${_chk_url}" ]; then
	_expected_sum="$(curl -sL "${_chk_url}" 2> "/dev/null" | grep -E "^SHA256 \(${_iso_file}\) = " | awk -F'= ' '{print $2}' | tr -d ' \r\n' || true)"
fi

if [ -n "${_expected_sum}" ]; then
	if command -v sha256sum > "/dev/null" 2>&1; then
		echo "${_expected_sum}  ${_target_path}" | sha256sum -c - > "/dev/null" 2>&1 || {
			_ui_err "Falha na verificação de integridade SHA256!"
			exit 1
		}
		_ui_ok "Soma SHA256 validada com sucesso!"
	elif command -v sha256 > "/dev/null" 2>&1; then
		_calc="$(sha256 -q "${_target_path}" 2> "/dev/null" || true)"
		if [ "${_calc}" = "${_expected_sum}" ]; then
			_ui_ok "Soma SHA256 validada com sucesso!"
		else
			_ui_err "Falha na verificação de integridade SHA256!"
			exit 1
		fi
	fi
fi

_ui_ok "ISO do Fedora Server pronta para uso em: ${_target_path}"
