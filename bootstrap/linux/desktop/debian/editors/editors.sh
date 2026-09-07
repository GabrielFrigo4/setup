#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Debian Code Editors Package Installation
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Debian Editors]: Instalando editores de código via apt e flatpak..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} apt install --yes mg micro neovim vim emacs geany

if command -v flatpak > "/dev/null" 2>&1; then
	flatpak install --assumeyes flathub com.visualstudio.code 2> "/dev/null" || true
fi

${ELEVATE} mkdir -p "/etc/apt/keyrings"
curl -fsSL "https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg" | \
	${ELEVATE} gpg --dearmor --yes -o "/etc/apt/keyrings/antigravity-repo-key.gpg" 2> "/dev/null" || true
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
	${ELEVATE} tee "/etc/apt/sources.list.d/antigravity.list" > "/dev/null"

${ELEVATE} apt update 2> "/dev/null" || true
${ELEVATE} apt install --yes antigravity 2> "/dev/null" || true

echo "✅ [Debian Editors]: Editores instalados com sucesso!"
