#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Base System Terminals
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Alinhando e padronizando /etc/ttys..."

TARGET="/etc/ttys"

if [ ! -f "${TARGET}" ]; then
	_ui_warn "Arquivo ${TARGET} não encontrado."
	exit 0
fi

_ly_enabled="NO"
if [ "$(sysrc -n ly_enable 2> "/dev/null" || true)" = "YES" ]; then
	_ly_enabled="YES"
fi

_ly_tty="ttyv1"
for _ly_conf in "/usr/local/etc/ly/config.ini" "/etc/ly/config.ini"; do
	if [ -f "${_ly_conf}" ]; then
		_cfg_tty="$(grep -E "^[[:space:]]*tty[[:space:]]*=" "${_ly_conf}" 2> "/dev/null" | awk -F= '{print $2}' | tr -d '[:space:]')"
		case "${_cfg_tty}" in
			[0-9]*)
				_idx=$(( _cfg_tty - 1 ))
				[ "${_idx}" -ge 0 ] && _ly_tty="ttyv${_idx}"
				;;
			ttyv*)
				_ly_tty="${_cfg_tty}"
				;;
		esac
		break
	fi
done

TMP_FILE="$(mktemp "/tmp/ttys.aligned.XXXXXX")"

while IFS= read -r line || [ -n "${line}" ]; do
	case "${line}" in
		""|[[:space:]]*)
			case "${line}" in
				*[![:space:]]*) ;;
				*) printf "\n" >> "${TMP_FILE}"; continue ;;
			esac
			;;
	esac

	trimmed=$(echo "${line}" | sed "s/^[[:space:]]*//")
	case "${trimmed}" in
		\#*)
			printf "%s\n" "${line}" >> "${TMP_FILE}"
			continue
			;;
	esac

	name=$(echo "${trimmed}" | awk '{print $1}')
	rest=$(echo "${trimmed}" | sed -e "s/^[^[:space:]]*[[:space:]]*//")

	case "${rest}" in
		\"*)
			getty="\"$(echo "${rest}" | cut -d\" -f2)\""
			after_getty=$(echo "${rest}" | cut -d\" -f3-)
			set -- ${after_getty}
			type="${1:-}"
			status="${2:-}"
			if [ $# -ge 2 ]; then
				shift 2
				comments="$*"
			else
				comments=""
			fi
			;;
		*)
			set -- ${rest}
			getty="${1:-}"
			type="${2:-}"
			status="${3:-}"
			if [ $# -ge 3 ]; then
				shift 3
				comments="$*"
			else
				comments=""
			fi
			;;
	esac

	if [ "${_ly_enabled}" = "YES" ] && [ "${name}" = "${_ly_tty}" ]; then
		status="off"
	fi

	if [ -n "${comments}" ]; then
		printf "%-7s %-31s %-7s %-10s %s\n" "${name}" "${getty}" "${type}" "${status}" "${comments}" >> "${TMP_FILE}"
	else
		printf "%-7s %-31s %-7s %s\n" "${name}" "${getty}" "${type}" "${status}" >> "${TMP_FILE}"
	fi
done < "${TARGET}"

if [ -n "${ELEVATE}" ]; then
	${ELEVATE} cp "${TMP_FILE}" "${TARGET}"
	${ELEVATE} chmod 0644 "${TARGET}"
else
	cp "${TMP_FILE}" "${TARGET}"
	chmod 0644 "${TARGET}"
fi

rm -f "${TMP_FILE}"

### --------------------------------
### KEYMAP E NAVEGACAO CONSOLE VT
### --------------------------------
if command -v kbdcontrol > "/dev/null" 2>&1; then
	_esc=$'\e'
	${ELEVATE} kbdcontrol -f 65 "${_esc}[1;5D" > "/dev/null" 2>&1 || true
	${ELEVATE} kbdcontrol -f 66 "${_esc}[1;5C" > "/dev/null" 2>&1 || true
fi

_ui_ok "Configuração do /etc/ttys alinhada com sucesso!"
