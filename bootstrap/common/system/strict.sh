#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Strict Privilege Setup (Doas & Sudo - Password Always)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Privileges/Strict]: Configurando elevação estrita (senha sempre)..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

if [ "$(uname -s)" = "FreeBSD" ] || command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes doas sudo
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
	echo "⚠️ [Privileges/Strict]: Gerenciador de pacotes não suportado automaticamente."
	TARGET_GROUP="wheel"
	DOAS_CONF="/etc/doas.conf"
	SUDOERS_DIR="/etc/sudoers.d"
fi

cat << EOF | ${ELEVATE} tee "${DOAS_CONF}" > "/dev/null"
permit :${TARGET_GROUP}
EOF
${ELEVATE} chmod 0440 "${DOAS_CONF}"

mkdir -p "${SUDOERS_DIR}"
cat << EOF | ${ELEVATE} tee "${SUDOERS_DIR}/${TARGET_GROUP}" > "/dev/null"
Defaults timestamp_timeout=0
%${TARGET_GROUP} ALL=(ALL:ALL) ALL
EOF
${ELEVATE} chmod 0440 "${SUDOERS_DIR}/${TARGET_GROUP}"

echo "✅ [Privileges/Strict]: Configurado com sucesso para o grupo '${TARGET_GROUP}' (0440, exige senha sempre)!"
