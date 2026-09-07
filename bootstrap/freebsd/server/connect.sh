#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Tool: FreeBSD Server Dynamic Connect (SSH / SCP via virsh)
# ------------------------------------------------------------------------------
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

case "${ACTION}" in
	ssh)
		echo "🔌 [FreeBSD Connect]: Conectando via SSH em freebsd@${FREEBSD_IP}..."
		exec ssh "freebsd@${FREEBSD_IP}"
		;;
	scp)
		shift
		if [ "$#" -lt 2 ]; then
			echo "Uso: $0 scp <origem> <destino>" >&2
			exit 1
		fi
		exec scp "$@"
		;;
	*)
		exec ssh "freebsd@${FREEBSD_IP}" "$@"
		;;
esac
