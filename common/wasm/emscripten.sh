#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal WebAssembly Toolchains (Emscripten)
# ----------------------------------------------------------------
set -eu

echo "📦 [Wasm]: Instalando toolchain WebAssembly (Emscripten)..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes emscripten
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
	echo "❌ [Wasm]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Wasm]: Emscripten instalado com sucesso!"
