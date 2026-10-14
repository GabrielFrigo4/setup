#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Cloud Server Dynamic Connect (SSH / SCP via Vault)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

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

SERVER="${1:-personal}"

case "${SERVER}" in
	personal|oracle-personal)
		SERVER_IP="${PERSONAL_SERVER_IP:-144.22.210.65}"
		SERVER_USER="${PERSONAL_SERVER_USER:-ubuntu}"
		SERVER_KEY="$(_resolve_vault_ssh_key "${PERSONAL_SERVER_KEY:-}" "ssh-key-personal-server.key" || true)"
		;;
	venture|oracle-venture)
		SERVER_IP="${VENTURE_SERVER_IP:-137.131.238.161}"
		SERVER_USER="${VENTURE_SERVER_USER:-ubuntu}"
		SERVER_KEY="$(_resolve_vault_ssh_key "${VENTURE_SERVER_KEY:-}" "ssh-key-venture-server.key" || true)"
		;;
	*)
		_ui_err "Uso: $0 [personal | venture] [comando/argumentos adicionais]"
		exit 1
		;;
esac

[ "$#" -ge 1 ] && shift

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

if [ -n "${SERVER_KEY}" ]; then
	if [ "$#" -gt 0 ]; then
		exec ssh ${_ssh_opts} -i "${SERVER_KEY}" "${SERVER_USER}@${SERVER_IP}" "$@"
	else
		_ui_step "Conectando a ${SERVER_USER}@${SERVER_IP} (${SERVER})..."
		exec ssh ${_ssh_opts} -i "${SERVER_KEY}" "${SERVER_USER}@${SERVER_IP}"
	fi
else
	if [ "$#" -gt 0 ]; then
		exec ssh ${_ssh_opts} "${SERVER_USER}@${SERVER_IP}" "$@"
	else
		_ui_step "Conectando a ${SERVER_USER}@${SERVER_IP} (${SERVER})..."
		exec ssh ${_ssh_opts} "${SERVER_USER}@${SERVER_IP}"
	fi
fi
