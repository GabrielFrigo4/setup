#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Debian GameDev & Graphics Libraries
# ----------------------------------------------------------------
set -eu

echo "📦 [Debian GameDev]: Instalando Emscripten, GLFW e SDL3..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} apt update 2> "/dev/null" || true

${ELEVATE} apt install --yes \
	emscripten \
	libglfw3-dev \
	libsdl3-dev \
	libsdl3-image-dev \
	libsdl3-net-dev \
	libsdl3-ttf-dev \
	libsdl3-mixer-dev \
	spirv-cross

${ELEVATE} apt install --yes libsdl3-shadercross-dev 2> "/dev/null" || true

echo "✅ [Debian GameDev]: Bibliotecas e ferramentas instaladas com sucesso!"
