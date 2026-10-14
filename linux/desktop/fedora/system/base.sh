#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Fedora Base System & Workspace Init
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando sistema base, filesystems e workspace Fedora..."

${ELEVATE} dnf install --assumeyes fuse-sshfs zsh

if command -v zsh > "/dev/null" 2>&1; then
	TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	ZSH_BIN="$(command -v zsh)"
	if [ "$(getent passwd "${TARGET_USER}" 2> "/dev/null" | cut -d: -f7)" != "${ZSH_BIN}" ]; then
		${ELEVATE} chsh -s "${ZSH_BIN}" "${TARGET_USER}" 2> "/dev/null" || true
	fi
fi

${ELEVATE} systemctl mask --now fwupd fwupd.socket 2> "/dev/null" || true
${ELEVATE} rm -rf /var/cache/fwupd/

MODELOS_DIR="${HOME}/Modelos"
mkdir -p "${MODELOS_DIR}"

touch "${MODELOS_DIR}/Empty"
touch "${MODELOS_DIR}/Text.txt"
touch "${MODELOS_DIR}/Markdown.md"

cat << 'EOF' > "${MODELOS_DIR}/Shell.sh"
#!/usr/bin/env sh
set -eu

EOF
chmod 0755 "${MODELOS_DIR}/Shell.sh"

_ui_ok "Sistema base configurado com sucesso!"
