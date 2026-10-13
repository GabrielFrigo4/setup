#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Server Dynamic Connect (SSH / SCP via virsh)
# ----------------------------------------------------------------
set -eu

VM_NAME="${FREEBSD_VM_NAME:-FreeBSD}"
ACTION="${1:-ssh}"

FREEBSD_IP="$(virsh --connect "qemu:///system" domifaddr "${VM_NAME}" 2> "/dev/null" \
	| awk '$3 == "ipv4" {print $4}' | cut -d'/' -f1 || true)"

if [ -z "${FREEBSD_IP}" ]; then
	echo "❌ [FreeBSD Connect]: IP da VM '${VM_NAME}' não detectado via virsh." >&2
	echo "   Certifique-se de que a VM está em execução ('virsh start ${VM_NAME}')." >&2
	exit 1
fi

_ssh_opts=""
case "${RAW_TTY:-}${LC_RAW_TTY:-}" in
	1|true|yes) _ssh_opts="-o SendEnv=LC_RAW_TTY -o SetEnv=LC_RAW_TTY=1" ;;
	*)
		case "$(command tty 2> "/dev/null")" in
			/dev/tty[0-9]*|/dev/ttyv*|/dev/console)
				_ssh_opts="-o SendEnv=LC_RAW_TTY -o SetEnv=LC_RAW_TTY=1"
				;;
		esac
		;;
esac

case "${ACTION}" in
	ssh)
		echo "🔌 [FreeBSD Connect]: Conectando via SSH em freebsd@${FREEBSD_IP}..."
		exec ssh ${_ssh_opts} "freebsd@${FREEBSD_IP}"
		;;
	scp)
		[ "$#" -ge 1 ] && shift
		if [ "$#" -lt 2 ]; then
			echo "Uso: $0 scp <origem> <destino>" >&2
			exit 1
		fi
		exec scp "$@"
		;;
	*)
		exec ssh ${_ssh_opts} "freebsd@${FREEBSD_IP}" "$@"
		;;
esac
