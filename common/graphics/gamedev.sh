#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal GameDev & Graphics Libraries
# ----------------------------------------------------------------
set -eu

echo "📦 [GameDev]: Detectando ecossistema e instalando GLFW, SDL3 e Emscripten..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
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
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		glfw-devel \
		SDL3-devel \
		SDL3_image-devel \
		SDL3_ttf-devel \
		SDL3_net-devel \
		spirv-cross-devel
	${ELEVATE} dnf install --assumeyes SDL3_mixer-devel 2> "/dev/null" || true
	${ELEVATE} dnf install --assumeyes emscripten 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		emscripten \
		libglfw3-dev \
		libsdl3-dev \
		libsdl3-image-dev \
		libsdl3-net-dev \
		libsdl3-ttf-dev \
		libsdl3-mixer-dev \
		spirv-cross
	${ELEVATE} apt-get install --yes libsdl3-shadercross-dev 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-emscripten \
			mingw-w64-ucrt-x86_64-glfw \
			mingw-w64-ucrt-x86_64-sdl3 \
			mingw-w64-ucrt-x86_64-sdl3-image \
			mingw-w64-ucrt-x86_64-sdl3-mixer \
			mingw-w64-ucrt-x86_64-sdl3-net \
			mingw-w64-ucrt-x86_64-sdl3-ttf
	else
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
	fi
else
	echo "❌ [GameDev]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [GameDev]: Toolchains e bibliotecas instaladas com sucesso!"
