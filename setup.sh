#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Setup Orchestrator
# ----------------------------------------------------------------
set -eu

if [ -n "${SETUP_DIR:-}" ] && [ -d "${SETUP_DIR}" ]; then
	_repo_root="${SETUP_DIR}"
else
	case "${0}" in
		-*|"") _script_dir="" ;;
		*/*)  _script_dir="${0%/*}" ;;
		*)    _script_dir="." ;;
	esac
	if [ -n "${_script_dir}" ] && [ -d "${_script_dir}" ]; then
		_repo_root="$(cd "${_script_dir}" && pwd)"
	else
		_repo_root="${PWD}"
	fi
fi

. "${_repo_root}/core/ui.sh"
. "${_repo_root}/core/elevate.sh"
. "${_repo_root}/core/detect.sh"
. "${_repo_root}/core/perms.sh"

_self_heal_perms "${_repo_root}"

_dry_run=0
_profile=""

for _arg in "$@"; do
	case "${_arg}" in
		--dry-run) _dry_run=1 ;;
		--profile=*) _profile="${_arg#*=}" ;;
		doctor) _profile="doctor" ;;
		audit) python3 "${_repo_root}/.scripts/audit/all.py"; exit 0 ;;
		test)
			find "${_repo_root}" -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
			_ui_ok "Todas as receitas POSIX estão válidas!"
			exit 0
			;;
		--help|-h|help)
			echo "Uso: $0 [doctor|audit|test] [--dry-run] [--profile=<perfil>]"
			echo "Perfis: fedora-desktop, arch-desktop, debian-desktop, freebsd-desktop, server, containers, common, doctor"
			exit 0
			;;
	esac
done

_ui_banner "Universal Setup Orchestrator"
_ui_step "Inicializando orquestrador do sistema em: ${_repo_root}"
[ "${_dry_run}" -eq 1 ] && _ui_warn "Modo DRY-RUN ativado (nenhum comando será executado)."

_run_recipe() {
	_script="$1"
	if [ -f "${_script}" ]; then
		_ui_sub "Executando: ${_script}"
		if [ "${_dry_run}" -eq 0 ]; then
			sh "${_script}"
		fi
	else
		_ui_warn "Receita não encontrada: ${_script}"
	fi
}

_ui_info "Sistema detectado: ${DETECTED_OS} (${DETECTED_DISTRO})"

### ================================
### PROFILE SELECTION
### ================================
if [ -z "${_profile}" ]; then
	echo ""
	echo "Escolha o perfil de provisionamento desejado:"
	echo "  1) Desktop Completo (${DETECTED_DISTRO})"
	echo "  2) Servidor / Headless"
	echo "  3) Containers & Virtualização"
	echo "  4) Fontes & Linters Comuns"
	echo "  5) Executar Diagnóstico (Setup Doctor)"
	echo "  q) Sair"
	echo ""
	printf "Opção [1-5]: "
	read -r _choice || _choice="q"
else
	case "${_profile}" in
		fedora-desktop|arch-desktop|debian-desktop|freebsd-desktop) _choice="1" ;;
		server) _choice="2" ;;
		containers) _choice="3" ;;
		common) _choice="4" ;;
		doctor) _choice="5" ;;
		*) _choice="q" ;;
	esac
fi

case "${_choice}" in
	1)
		_ui_step "Provisionando Desktop para ${DETECTED_OS}/${DETECTED_DISTRO}..."
		if [ "${DETECTED_OS}" = "freebsd" ]; then
			_run_recipe "${_repo_root}/freebsd/desktop/all.sh"
		elif [ "${DETECTED_DISTRO}" = "fedora" ]; then
			_run_recipe "${_repo_root}/linux/desktop/fedora/all.sh"
		elif [ "${DETECTED_DISTRO}" = "arch" ]; then
			_run_recipe "${_repo_root}/linux/desktop/arch/all.sh"
		elif [ "${DETECTED_DISTRO}" = "debian" ]; then
			_run_recipe "${_repo_root}/linux/desktop/debian/all.sh"
		else
			_ui_warn "Distribuição '${DETECTED_DISTRO}' não possui bundle automatizado 'all.sh'."
		fi
		;;
	2)
		_ui_step "Provisionando Servidor..."
		_run_recipe "${_repo_root}/linux/server/connect.sh"
		;;
	3)
		_ui_step "Provisionando Containers..."
		if [ "${DETECTED_OS}" = "freebsd" ]; then
			_run_recipe "${_repo_root}/freebsd/container/jails.sh"
			_run_recipe "${_repo_root}/freebsd/container/bhyve.sh"
		else
			_run_recipe "${_repo_root}/linux/container/incus.sh"
			_run_recipe "${_repo_root}/linux/container/podman.sh"
		fi
		;;
	4)
		_ui_step "Instalando Fontes e Linters comuns..."
		_run_recipe "${_repo_root}/common/fonts/fonts.sh"
		_run_recipe "${_repo_root}/common/linters/linters.sh"
		;;
	5)
		_ui_step "Executando diagnóstico..."
		sh "${_repo_root}/.scripts/audit/doctor.sh"
		;;
	*)
		_ui_info "Operação cancelada."
		exit 0
		;;
esac

_ui_ok "Processo concluído com sucesso!"
exit 0
