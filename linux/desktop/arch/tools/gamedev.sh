#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux GameDev & Graphics Libraries
# ----------------------------------------------------------------
set -eu

echo "📦 [Arch GameDev]: Instalando Emscripten, GLFW e ecossistema SDL3..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pacman -S --needed --noconfirm \
	emscripten \
	glfw \
	sdl3 \
	sdl3_image \
	spirv-cross

if command -v yay > "/dev/null" 2>&1; then
	yay -S --needed --noconfirm \
		sdl3_net \
		sdl3_ttf-git \
		sdl3_mixer-git \
		sdl3_shadercross-git 2> "/dev/null" || true
fi

echo "✅ [Arch GameDev]: Bibliotecas e ferramentas instaladas com sucesso!"
