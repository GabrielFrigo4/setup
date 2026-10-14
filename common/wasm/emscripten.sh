#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal WebAssembly Toolchains (Emscripten)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v emcc > "/dev/null" 2>&1; then
	_ui_ok "Toolchain WebAssembly (Emscripten) já instalada."
	exit 0
fi

_ui_step "Instalando toolchain WebAssembly (Emscripten)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes devel/emscripten
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes emscripten 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes emscripten
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-emscripten
	else
		${ELEVATE} pacman -S --needed --noconfirm emscripten
	fi
elif command -v scoop > "/dev/null" 2>&1; then
	scoop install emscripten 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Emscripten instalado com sucesso!"
