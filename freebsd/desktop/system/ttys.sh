#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Base System Terminals (/etc/ttys)
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD ttys]: Alinhando e padronizando /etc/ttys..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

TARGET="/etc/ttys"

if [ ! -f "${TARGET}" ]; then
	echo "⚠️  [FreeBSD ttys]: Arquivo ${TARGET} não encontrado."
	exit 0
fi

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
			type="$1"
			status="$2"
			shift 2 2> "/dev/null" || true
			comments="$*"
			;;
		*)
			set -- ${rest}
			getty="$1"
			type="$2"
			status="$3"
			shift 3 2> "/dev/null" || true
			comments="$*"
			;;
	esac

	if [ -n "${comments}" ]; then
		printf "%-7s %-31s %-7s %-10s %s\n" "${name}" "${getty}" "${type}" "${status}" "${comments}" >> "${TMP_FILE}"
	else
		printf "%-7s %-31s %-7s %s\n" "${name}" "${getty}" "${type}" "${status}" >> "${TMP_FILE}"
	fi
done < "${TARGET}"

${ELEVATE} cp "${TARGET}" "${TARGET}.bak"
${ELEVATE} cp "${TMP_FILE}" "${TARGET}"
${ELEVATE} chmod 0644 "${TARGET}"
rm -f "${TMP_FILE}"

echo "✅ [FreeBSD ttys]: Configuração do /etc/ttys alinhada com sucesso!"
