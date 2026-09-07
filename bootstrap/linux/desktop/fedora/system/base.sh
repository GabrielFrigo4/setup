#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Fedora Base System, Filesystems & Workspace Initialization
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Fedora Base]: Configurando sistema base, filesystems e workspace..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} dnf install --assumeyes fuse-sshfs

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

echo "✅ [Fedora Base]: Sistema base configurado com sucesso!"
