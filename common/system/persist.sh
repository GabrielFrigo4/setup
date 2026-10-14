#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Session Persistent Privilege Setup
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando elevação com persistência de sessão..."

if [ "$(uname -s)" = "FreeBSD" ] || command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes security/doas security/sudo
	TARGET_GROUP="wheel"
	DOAS_CONF="/usr/local/etc/doas.conf"
	SUDOERS_DIR="/usr/local/etc/sudoers.d"
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes opendoas sudo
	TARGET_GROUP="wheel"
	DOAS_CONF="/etc/doas.conf"
	SUDOERS_DIR="/etc/sudoers.d"
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt update 2> "/dev/null" || true
	${ELEVATE} apt install --yes doas sudo
	TARGET_GROUP="sudo"
	DOAS_CONF="/etc/doas.conf"
	SUDOERS_DIR="/etc/sudoers.d"
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm opendoas sudo
	TARGET_GROUP="wheel"
	DOAS_CONF="/etc/doas.conf"
	SUDOERS_DIR="/etc/sudoers.d"
else
	_ui_warn "Gerenciador de pacotes não suportado automaticamente."
	TARGET_GROUP="wheel"
	DOAS_CONF="/etc/doas.conf"
	SUDOERS_DIR="/etc/sudoers.d"
fi

if [ -f "${DOAS_CONF}" ] && grep -q "permit persist :${TARGET_GROUP}" "${DOAS_CONF}" 2> "/dev/null" && [ -f "${SUDOERS_DIR}/${TARGET_GROUP}" ] && grep -q "%${TARGET_GROUP} ALL=(ALL:ALL) ALL" "${SUDOERS_DIR}/${TARGET_GROUP}" 2> "/dev/null"; then
	_ui_ok "Elevação com persistência já configurada para o grupo '${TARGET_GROUP}'."
	exit 0
fi

cat << EOF | ${ELEVATE} tee "${DOAS_CONF}" > "/dev/null"
permit persist :${TARGET_GROUP}
EOF
${ELEVATE} chmod 0440 "${DOAS_CONF}"

mkdir -p "${SUDOERS_DIR}"
cat << EOF | ${ELEVATE} tee "${SUDOERS_DIR}/${TARGET_GROUP}" > "/dev/null"
%${TARGET_GROUP} ALL=(ALL:ALL) ALL
EOF
${ELEVATE} chmod 0440 "${SUDOERS_DIR}/${TARGET_GROUP}"

_ui_ok "Configurado com sucesso para o grupo '${TARGET_GROUP}' (0440, exige senha e salva sessão)!"
