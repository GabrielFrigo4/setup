#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Zellij Terminal Workspace & Multiplexer
# ----------------------------------------------------------------
set -eu

echo "📦 [Zellij]: Instalando o multiplexador moderno Zellij..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

if command -v zellij > "/dev/null" 2>&1; then
	echo "  ℹ️ Zellij já está instalado em $(command -v zellij)."
	exit 0
fi

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes sysutils/zellij
elif command -v pacman > "/dev/null" 2>&1 && [ -z "${MSYSTEM-}" ]; then
	${ELEVATE} pacman -S --needed --noconfirm zellij
elif command -v dnf > "/dev/null" 2>&1 && ${ELEVATE} dnf install --assumeyes zellij 2> "/dev/null"; then
	true
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Zellij.Zellij --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
elif [ "$(uname -s)" = "Linux" ]; then
	echo "  ↳ Baixando binário oficial estático musl do Zellij..."
	_arch="$(uname -m)"
	case "${_arch}" in
		x86_64|amd64) _target="x86_64-unknown-linux-musl" ;;
		aarch64|arm64) _target="aarch64-unknown-linux-musl" ;;
		*)
			echo "❌ [Zellij]: Arquitetura não suportada para binário pré-compilado: ${_arch}" >&2
			exit 1
			;;
	esac
	_url="https://github.com/zellij-org/zellij/releases/latest/download/zellij-${_target}.tar.gz"
	_tmp_dir="/tmp/zellij_install_$$"
	mkdir -p "${_tmp_dir}"
	curl -fsSL "${_url}" | tar -xz -C "${_tmp_dir}"
	${ELEVATE} mkdir -p "/usr/local/bin"
	${ELEVATE} cp -f "${_tmp_dir}/zellij" "/usr/local/bin/zellij"
	${ELEVATE} chmod 0755 "/usr/local/bin/zellij"
	rm -rf "${_tmp_dir}"
else
	echo "❌ [Zellij]: Plataforma ou gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Zellij]: Multiplexador Zellij instalado com sucesso!"
