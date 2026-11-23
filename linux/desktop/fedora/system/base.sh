#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Fedora Base System & Workspace Init
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando sistema base, filesystems e workspace Fedora..."

${ELEVATE} dnf install --assumeyes \
	fuse-sshfs \
	zsh \
	cmake \
	cmake-gui \
	cmake-doc

if command -v zsh > "/dev/null" 2>&1; then
	TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"
	ZSH_BIN="$(command -v zsh)"
	if [ "$(getent passwd "${TARGET_USER}" 2> "/dev/null" | cut -d: -f7)" != "${ZSH_BIN}" ]; then
		${ELEVATE} chsh -s "${ZSH_BIN}" "${TARGET_USER}" 2> "/dev/null" || true
	fi
fi

${ELEVATE} systemctl mask --now fwupd fwupd.socket 2> "/dev/null" || true
${ELEVATE} rm -rf /var/cache/fwupd/

_templates_dir="$(xdg-user-dir TEMPLATES 2> "/dev/null" || echo "${HOME}/Templates")"
[ -n "${_templates_dir}" ] || _templates_dir="${HOME}/Templates"
mkdir -p "${_templates_dir}"

touch "${_templates_dir}/Empty"
touch "${_templates_dir}/Text.txt"
touch "${_templates_dir}/Markdown.md"

cat << 'EOF' > "${_templates_dir}/Shell.sh"
#!/usr/bin/env sh
set -eu

EOF
chmod 0755 "${_templates_dir}/Shell.sh"

_console_recipe="${_setup_root}/linux/common/system/console.sh"
if [ -f "${_console_recipe}" ]; then
	sh "${_console_recipe}"
fi

_ui_ok "Sistema base configurado com sucesso!"
