#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Reverse Engineering & Debugging Tools
# ----------------------------------------------------------------
set -eu

echo "📦 [Security]: Instalando ferramentas de análise binária e depuração..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		lldb \
		valgrind \
		radare2 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		lldb \
		valgrind \
		strace 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		lldb \
		valgrind \
		strace \
		radare2 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-lldb 2> "/dev/null" || true
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			lldb \
			valgrind \
			strace \
			radare2 2> "/dev/null" || true
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id radareorg.radare2 --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	echo "❌ [Security]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Security]: Ferramentas de análise binária instaladas com sucesso!"
