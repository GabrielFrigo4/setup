#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Server Dynamic Connect (SSH / SCP via virsh)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

VM_NAME="${FREEBSD_VM_NAME:-FreeBSD}"
ACTION="${1:-ssh}"

FREEBSD_IP="$(virsh --connect "qemu:///system" domifaddr "${VM_NAME}" 2> "/dev/null" \
	| awk '$3 == "ipv4" {print $4}' | cut -d'/' -f1 || true)"

if [ -z "${FREEBSD_IP}" ]; then
	_ui_err "IP da VM '${VM_NAME}' não detectado via virsh."
	_ui_sub "Certifique-se de que a VM está em execução ('virsh start ${VM_NAME}')."
	exit 1
fi

_ssh_opts=""
case "${RAW_TTY:-}" in
	1|true|yes) _ssh_opts="-o SendEnv=LC_RAW_TTY -o SetEnv=LC_RAW_TTY=1" ;;
	*)
		case "${LC_RAW_TTY:-}" in
			1|true|yes) _ssh_opts="-o SendEnv=LC_RAW_TTY -o SetEnv=LC_RAW_TTY=1" ;;
			*)
				case "$(command tty 2> "/dev/null")" in
					/dev/tty[0-9]*|/dev/ttyv*|/dev/console)
						_ssh_opts="-o SendEnv=LC_RAW_TTY -o SetEnv=LC_RAW_TTY=1"
						;;
				esac
				;;
		esac
		;;
esac

case "${ACTION}" in
	ssh)
		_ui_step "Conectando via SSH em freebsd@${FREEBSD_IP}..."
		exec ssh ${_ssh_opts} "freebsd@${FREEBSD_IP}"
		;;
	scp)
		[ "$#" -ge 1 ] && shift
		if [ "$#" -lt 2 ]; then
			_ui_err "Uso: $0 scp <origem> <destino>"
			exit 1
		fi
		exec scp "$@"
		;;
	*)
		exec ssh ${_ssh_opts} "freebsd@${FREEBSD_IP}" "$@"
		;;
esac
