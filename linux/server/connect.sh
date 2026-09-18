#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Cloud Server Dynamic Connect (SSH / SCP via Vault)
# ----------------------------------------------------------------
set -eu

_resolve_vault_ssh_key() {
	_explicit_key="${1:-}"
	_key_name="${2:-}"

	if [ -n "${_explicit_key}" ] && [ -f "${_explicit_key}" ]; then
		chmod 0600 "${_explicit_key}" 2> "/dev/null" || true
		echo "${_explicit_key}"
		return 0
	fi

	for _candidate in \
		"${VAULT_DIR:-}/keys/${_key_name}" \
		"${XDG_DATA_HOME:-${HOME}/.local/share}/vault/keys/${_key_name}" \
		"${XDG_CONFIG_HOME:-${HOME}/.config}/vault/keys/${_key_name}" \
		"${HOME}/.vault/keys/${_key_name}" \
		"/usr/local/share/vault/keys/${_key_name}"; do
		if [ -n "${_candidate}" ] && [ -f "${_candidate}" ]; then
			chmod 0600 "${_candidate}" 2> "/dev/null" || true
			echo "${_candidate}"
			return 0
		fi
	done

	return 1
}

SERVER="${1:-frigo}"

case "${SERVER}" in
	frigo|oracle-frigo)
		SERVER_IP="${FRIGO_SERVER_IP:-144.22.210.65}"
		SERVER_USER="${FRIGO_SERVER_USER:-ubuntu}"
		SERVER_KEY="$(_resolve_vault_ssh_key "${FRIGO_SERVER_KEY:-}" "ssh-key-frigo-server.key" || true)"
		;;
	orbs|oracle-orbs)
		SERVER_IP="${ORBS_SERVER_IP:-137.131.238.161}"
		SERVER_USER="${ORBS_SERVER_USER:-ubuntu}"
		SERVER_KEY="$(_resolve_vault_ssh_key "${ORBS_SERVER_KEY:-}" "ssh-key-orbs-server.key" || true)"
		;;
	*)
		echo "Uso: $0 [frigo | orbs] [comando/argumentos adicionais]" >&2
		exit 1
		;;
esac

shift 1 || true

if [ -n "${SERVER_KEY}" ]; then
	if [ "$#" -gt 0 ]; then
		exec ssh -i "${SERVER_KEY}" "${SERVER_USER}@${SERVER_IP}" "$@"
	else
		echo "🔌 [Server Connect]: Conectando a ${SERVER_USER}@${SERVER_IP} (${SERVER})..."
		exec ssh -i "${SERVER_KEY}" "${SERVER_USER}@${SERVER_IP}"
	fi
else
	if [ "$#" -gt 0 ]; then
		exec ssh "${SERVER_USER}@${SERVER_IP}" "$@"
	else
		echo "🔌 [Server Connect]: Conectando a ${SERVER_USER}@${SERVER_IP} (${SERVER})..."
		exec ssh "${SERVER_USER}@${SERVER_IP}"
	fi
fi
