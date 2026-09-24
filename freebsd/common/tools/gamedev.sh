#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD GameDev & Graphics Libraries
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD GameDev]: Instalando Emscripten, GLFW e SDL3..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes \
	emscripten \
	glfw \
	sdl3 \
	sdl3_image \
	sdl3_net \
	sdl3_ttf \
	sdl3_mixer \
	spirv-cross

${ELEVATE} pkg install --yes sdl3_shadercross 2> "/dev/null" || true

echo "✅ [FreeBSD GameDev]: Bibliotecas e ferramentas instaladas com sucesso!"
