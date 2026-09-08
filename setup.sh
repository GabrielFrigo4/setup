#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Setup Orchestrator
# ----------------------------------------------------------------
set -eu

_repo_root="$(cd "$(dirname "$0")" && pwd)"
_dry_run=0
_profile=""

for _arg in "$@"; do
	case "${_arg}" in
		--dry-run) _dry_run=1 ;;
		--profile=*) _profile="${_arg#*=}" ;;
		--help|-h)
			echo "Uso: $0 [--dry-run] [--profile=<nome>]"
			echo "Perfis disponíveis: fedora-desktop, arch-desktop, freebsd-desktop, doctor"
			exit 0
			;;
	esac
done

echo "📦 [Setup] Inicializando orquestrador do sistema em: ${_repo_root}"
[ "${_dry_run}" -eq 1 ] && echo "  ⚠️ Modo DRY-RUN ativado (nenhum comando será executado)."

_run_recipe() {
	_script="$1"
	if [ -f "${_script}" ]; then
		echo "  ▶️ Executando: ${_script}"
		if [ "${_dry_run}" -eq 0 ]; then
			sh "${_script}"
		fi
	else
		echo "  ⚠️ Receita não encontrada: ${_script}"
	fi
}

### --------------------------------
### Detecção de Plataforma
### --------------------------------
_os="$(uname -s)"
_distro="generic"

if [ "${_os}" = "Linux" ] && [ -f "/etc/os-release" ]; then
	_distro="$(grep '^ID=' "/etc/os-release" | cut -d= -f2 | tr -d '"')"
fi

echo "  ↳ Sistema detectado: ${_os} (${_distro})"

### --------------------------------
### Seleção de Perfil / Menu
### --------------------------------
if [ -z "${_profile}" ]; then
	echo ""
	echo "Escolha o perfil de provisionamento desejado:"
	echo "  1) Desktop Completo (${_distro})"
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
		fedora-desktop|arch-desktop|freebsd-desktop) _choice="1" ;;
		server) _choice="2" ;;
		containers) _choice="3" ;;
		common) _choice="4" ;;
		doctor) _choice="5" ;;
		*) _choice="q" ;;
	esac
fi

case "${_choice}" in
	1)
		echo "↳ Provisionando Desktop para ${_os}/${_distro}..."
		if [ "${_os}" = "FreeBSD" ]; then
			_run_recipe "${_repo_root}/bootstrap/freebsd/desktop/all.sh"
		elif [ "${_distro}" = "fedora" ]; then
			_run_recipe "${_repo_root}/bootstrap/linux/desktop/fedora/all.sh"
		elif [ "${_distro}" = "arch" ]; then
			_run_recipe "${_repo_root}/bootstrap/linux/desktop/arch/all.sh"
		else
			echo "Distribuição '${_distro}' não possui bundle automatizado 'all.sh'."
		fi
		;;
	2)
		echo "↳ Provisionando Servidor..."
		_run_recipe "${_repo_root}/bootstrap/linux/server/connect.sh"
		;;
	3)
		echo "↳ Provisionando Containers..."
		if [ "${_os}" = "FreeBSD" ]; then
			_run_recipe "${_repo_root}/bootstrap/freebsd/container/jails.sh"
		else
			_run_recipe "${_repo_root}/bootstrap/linux/container/incus.sh"
			_run_recipe "${_repo_root}/bootstrap/linux/container/podman.sh"
		fi
		;;
	4)
		echo "↳ Instalando Fontes e Linters comuns..."
		_run_recipe "${_repo_root}/bootstrap/common/fonts/fonts.sh"
		_run_recipe "${_repo_root}/bootstrap/common/linters/linters.sh"
		;;
	5)
		echo "↳ Executando diagnóstico..."
		sh "${_repo_root}/scripts/audit/doctor.sh"
		;;
	*)
		echo "Operação cancelada."
		exit 0
		;;
esac

echo "✅ [Setup] Processo concluído com sucesso!"
exit 0
