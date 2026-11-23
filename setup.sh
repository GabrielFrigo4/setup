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
	[ -n "${_script_dir}" ] && [ -d "${_script_dir}" ] && _repo_root="$(cd "${_script_dir}" && pwd)" || _repo_root="${PWD}"
fi

. "${_repo_root}/core/ui.sh"
. "${_repo_root}/core/elevate.sh"
. "${_repo_root}/core/detect.sh"
. "${_repo_root}/core/perms.sh"
_self_heal_perms "${_repo_root}"

_dry_run=0; _profile=""
for _arg in "$@"; do
	case "${_arg}" in
		--dry-run) _dry_run=1 ;;
		--profile=*) _profile="${_arg#*=}" ;;
		--host=*) HOST_PROFILE="${_arg#*=}" ;;
		base|desktop|fedora-desktop|arch-desktop|debian-desktop|freebsd-desktop|virtualization|dev-host|host|server|doctor) _profile="${_arg}" ;;
		audit) PYTHONPYCACHEPREFIX="${PYTHONPYCACHEPREFIX:-${HOME}/.cache/pycache}" PYTHONDONTWRITEBYTECODE=1 python3 "${_repo_root}/.scripts/audit/all.py"; exit 0 ;;
		test) find "${_repo_root}" -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +; _ui_ok "Todas as receitas POSIX estão válidas!"; exit 0 ;;
		--help|-h|help)
			_ui_banner "Universal Setup Orchestrator"
			_ui_info "Uso: $0 [perfil] [--dry-run] [--profile=<perfil>] [--host=<nome>]"
			_ui_info "Perfis: base, desktop, fedora-desktop, arch-desktop, debian-desktop, freebsd-desktop, virtualization, dev-host, host, server, doctor, audit, test"
			exit 0 ;;
		*) _ui_err "Argumento desconhecido: ${_arg}"; exit 1 ;;
	esac
done

_run_recipe() {
	if [ -f "$1" ]; then
		_ui_sub "Executando: ${1#${_repo_root}/}"
		[ "${_dry_run}" -eq 0 ] && sh "$1" || true
	else
		_ui_warn "Receita não encontrada: $1"
	fi
}

_ui_banner "Universal Setup Orchestrator"
_ui_info "Sistema detectado: ${DETECTED_OS} (${DETECTED_DISTRO}) | Raiz: ${_repo_root}"
[ "${_dry_run}" -eq 1 ] && _ui_warn "Modo DRY-RUN ativado (nenhuma receita será executada)."

if [ -z "${_profile}" ]; then
	_ui_step "Selecione o perfil de provisionamento:"
	_ui_sub "1) base            (Clean Host portátil)"
	_ui_sub "2) desktop         (Desktop completo: ${DETECTED_DISTRO})"
	_ui_sub "3) virtualization  (Containers, Jails & Bhyve)"
	_ui_sub "4) dev-host        (Editores, Python, Docs, Shaders, AI & Linters — Opt-In)"
	_ui_sub "5) host            (Quirks de hardware em hosts/ — Opt-In)"
	_ui_sub "6) server          (Servidor Headless / Ubuntu)"
	_ui_sub "7) doctor          (Diagnóstico multiplataforma)"
	_ui_sub "q) Sair"
	printf "Opção [1-7]: "; read -r _choice || _choice="q"
	case "${_choice}" in
		1) _profile="base" ;; 2) _profile="desktop" ;; 3) _profile="virtualization" ;;
		4) _profile="dev-host" ;; 5) _profile="host" ;; 6) _profile="server" ;; 7) _profile="doctor" ;;
		*) _ui_info "Operação cancelada."; exit 0 ;;
	esac
fi

### ================================
### PROFILE EXECUTION DISPATCH
### ================================
case "${_profile}" in
	base)
		for _r in common/system/nopass.sh common/cli/core.sh common/vcs/tools.sh common/fonts/fonts.sh; do _run_recipe "${_repo_root}/${_r}"; done
		if [ "${DETECTED_OS}" = "freebsd" ]; then
			for _r in freebsd/common/system/sysctl.sh freebsd/desktop/system/system.sh freebsd/desktop/system/ttys.sh freebsd/desktop/system/zfs-arc.sh freebsd/desktop/devices/filesystem.sh; do _run_recipe "${_repo_root}/${_r}"; done
		elif [ "${DETECTED_DISTRO}" = "fedora" ] || [ "${DETECTED_DISTRO}" = "arch" ] || [ "${DETECTED_DISTRO}" = "debian" ]; then
			_run_recipe "${_repo_root}/linux/desktop/${DETECTED_DISTRO}/system/base.sh"
		elif [ "${DETECTED_DISTRO}" = "msys2" ]; then
			_run_recipe "${_repo_root}/windows/msys2/system.sh"; _run_recipe "${_repo_root}/windows/msys2/tools.sh"
		elif [ "${DETECTED_OS}" = "linux" ]; then
			_run_recipe "${_repo_root}/linux/common/system/console.sh"
		fi ;;
	fedora-desktop)  _run_recipe "${_repo_root}/linux/desktop/fedora/all.sh" ;;
	arch-desktop)    _run_recipe "${_repo_root}/linux/desktop/arch/all.sh" ;;
	debian-desktop)  _run_recipe "${_repo_root}/linux/desktop/debian/all.sh" ;;
	freebsd-desktop) _run_recipe "${_repo_root}/freebsd/desktop/all.sh" ;;
	desktop)
		if [ "${DETECTED_OS}" = "freebsd" ]; then _run_recipe "${_repo_root}/freebsd/desktop/all.sh"
		elif [ -f "${_repo_root}/linux/desktop/${DETECTED_DISTRO}/all.sh" ]; then _run_recipe "${_repo_root}/linux/desktop/${DETECTED_DISTRO}/all.sh"
		else _ui_warn "Distribuição '${DETECTED_DISTRO}' sem bundle 'all.sh'."; fi ;;
	virtualization)
		if [ "${DETECTED_OS}" = "freebsd" ]; then
			for _r in freebsd/container/jails.sh freebsd/container/bastille.sh freebsd/container/bhyve.sh freebsd/container/podman.sh; do _run_recipe "${_repo_root}/${_r}"; done
		else
			_run_recipe "${_repo_root}/linux/container/incus.sh"; _run_recipe "${_repo_root}/linux/container/podman.sh"
		fi ;;
	dev-host)
		for _r in common/editors/install.sh common/languages/python.sh common/docs/typesetting.sh common/graphics/shaders.sh common/ai/ollama.sh common/linters/prettier.sh common/linters/ruff.sh common/linters/mermaid.sh; do
			_run_recipe "${_repo_root}/${_r}"
		done ;;
	host)
		_hid="${HOST_PROFILE:-$(hostname -s 2> "/dev/null" | tr '[:upper:]' '[:lower:]' || true)}"
		if [ -n "${_hid}" ] && [ -f "${_repo_root}/hosts/${_hid}.sh" ]; then _run_recipe "${_repo_root}/hosts/${_hid}.sh"
		elif [ -n "${_hid}" ] && [ -f "${_repo_root}/hosts/${_hid}-${DETECTED_OS}.sh" ]; then _run_recipe "${_repo_root}/hosts/${_hid}-${DETECTED_OS}.sh"
		else _ui_warn "Perfil de hardware '${_hid:-desconhecido}' não encontrado em hosts/. Disponíveis: $(ls "${_repo_root}/hosts/"*.sh 2> "/dev/null" | xargs -n1 basename 2> "/dev/null" || echo nenhum)"; fi ;;
	server)
		_run_recipe "${_repo_root}/common/system/persist.sh"; _run_recipe "${_repo_root}/common/cli/core.sh"; _run_recipe "${_repo_root}/common/vcs/tools.sh"
		if [ "${DETECTED_OS}" = "freebsd" ]; then _run_recipe "${_repo_root}/freebsd/common/system/sysctl.sh"
		else [ "${DETECTED_PKG_MGR}" = "apt" ] && _run_recipe "${_repo_root}/linux/server/ubuntu.sh" || true; _run_recipe "${_repo_root}/linux/common/security/firewall.sh"; fi ;;
	doctor) sh "${_repo_root}/.scripts/audit/doctor.sh" ;;
	*) _ui_err "Perfil inválido: ${_profile}"; exit 1 ;;
esac

_ui_ok "Processo concluído com sucesso!"
