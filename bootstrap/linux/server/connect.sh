#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Tool: Linux Cloud Server Dynamic Connect (SSH / SCP via Vault)
# ------------------------------------------------------------------------------
set -eu

SERVER="${1:-frigo}"

case "${SERVER}" in
	frigo|oracle-frigo)
		SERVER_IP="${FRIGO_SERVER_IP:-144.22.210.65}"
		SERVER_USER="${FRIGO_SERVER_USER:-ubuntu}"
		SERVER_KEY="${FRIGO_SERVER_KEY:-${HOME}/.vault/keys/ssh-key-frigo-server.key}"
		;;
	orbs|oracle-orbs)
		SERVER_IP="${ORBS_SERVER_IP:-144.22.210.65}"
		SERVER_USER="${ORBS_SERVER_USER:-ubuntu}"
		SERVER_KEY="${ORBS_SERVER_KEY:-${HOME}/.vault/keys/ssh-key-orbs-server.key}"
		;;
	*)
		echo "Uso: $0 [frigo | orbs] [comando/argumentos adicionais]" >&2
		exit 1
		;;
esac

shift 1 || true

if [ "$#" -gt 0 ]; then
	exec ssh -i "${SERVER_KEY}" "${SERVER_USER}@${SERVER_IP}" "$@"
else
	echo "🔌 [Server Connect]: Conectando a ${SERVER_USER}@${SERVER_IP} (${SERVER})..."
	exec ssh -i "${SERVER_KEY}" "${SERVER_USER}@${SERVER_IP}"
fi
