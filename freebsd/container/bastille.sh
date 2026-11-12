#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: BastilleBSD Jail Automation Manager
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando gerenciador BastilleBSD..."

${ELEVATE} pkg install -y sysutils/bastille

${ELEVATE} mkdir -p \
	"/usr/local/bastille/jails" \
	"/usr/local/bastille/templates" \
	"/usr/local/bastille/cache" \
	"/usr/local/bastille/releases"

${ELEVATE} chmod 0755 \
	"/usr/local/bastille" \
	"/usr/local/bastille/jails" \
	"/usr/local/bastille/templates" \
	"/usr/local/bastille/cache" \
	"/usr/local/bastille/releases" 2> "/dev/null" || true

if [ -f "/usr/local/etc/rc.d/bastille" ]; then
	${ELEVATE} sed -i '' -E \
		-e 's|[[:space:]]*2>[[:space:]]*\\"/dev/null\\"||g' \
		-e 's|find[[:space:]]+/usr/local/bastille/jails/\*([[:space:]]+-maxdepth[[:space:]]+0)?|find /usr/local/bastille/jails -mindepth 1 -maxdepth 1|g' \
		-e 's|find[[:space:]]+\$\{bastille_jailsdir\}/\*([[:space:]]+-maxdepth[[:space:]]+0)?|find ${bastille_jailsdir} -mindepth 1 -maxdepth 1|g' \
		-e 's|find[[:space:]]+"\$\{bastille_jailsdir\}"/\*([[:space:]]+-maxdepth[[:space:]]+0)?|find "${bastille_jailsdir}" -mindepth 1 -maxdepth 1|g' \
		-e 's|find[[:space:]]+"\$\{bastille_jailsdir\}/\*"([[:space:]]+-maxdepth[[:space:]]+0)?|find "${bastille_jailsdir}" -mindepth 1 -maxdepth 1|g' \
		-e 's|find[[:space:]]+\$\{jailsdir\}/\*([[:space:]]+-maxdepth[[:space:]]+0)?|find ${jailsdir} -mindepth 1 -maxdepth 1|g' \
		-e 's|find[[:space:]]+"\$\{jailsdir\}"/\*([[:space:]]+-maxdepth[[:space:]]+0)?|find "${jailsdir}" -mindepth 1 -maxdepth 1|g' \
		-e 's|find[[:space:]]+"\$\{jailsdir\}/\*"([[:space:]]+-maxdepth[[:space:]]+0)?|find "${jailsdir}" -mindepth 1 -maxdepth 1|g' \
		-e 's|-mindepth[[:space:]]+1[[:space:]]+-maxdepth[[:space:]]+1[[:space:]]+-maxdepth[[:space:]]+0|-mindepth 1 -maxdepth 1|g' \
		"/usr/local/etc/rc.d/bastille" 2> "/dev/null" || true
fi

${ELEVATE} sysrc bastille_enable="YES"
sysrc -q bastille_list 2> "/dev/null" || ${ELEVATE} sysrc bastille_list="" > "/dev/null" 2>&1 || true

_cloned="$(sysrc -n cloned_interfaces 2> "/dev/null" || true)"
case " ${_cloned} " in
	*" lo1 "*) ;;
	*)
		${ELEVATE} sysrc cloned_interfaces+="lo1" > "/dev/null" 2>&1 || true
		;;
esac

${ELEVATE} sysrc ifconfig_lo1_name="bastille0" > "/dev/null" 2>&1 || true

if [ -d "/usr/local/bastille/jails" ]; then
	${ELEVATE} service bastille start 2> "/dev/null" || true
fi

_ui_ok "Gerenciador BastilleBSD pronto para uso!"
