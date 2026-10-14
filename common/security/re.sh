#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Reverse Engineering & Debugging Tools
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v valgrind > "/dev/null" 2>&1 || command -v lldb > "/dev/null" 2>&1; then
	_ui_ok "Ferramentas de análise binária e depuração já instaladas."
	exit 0
fi

_ui_step "Instalando ferramentas de análise binária e depuração..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		devel/valgrind \
		devel/radare2 2> "/dev/null" || true
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
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Ferramentas de análise binária instaladas com sucesso!"
