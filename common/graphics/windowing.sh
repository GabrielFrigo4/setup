#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Windowing & Multimedia Libraries (GLFW & SDL3)
# ----------------------------------------------------------------
set -eu

echo "📦 [Windowing]: Instalando GLFW e ecossistema SDL3..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		glfw \
		sdl3 \
		sdl3_image \
		sdl3_net \
		sdl3_ttf \
		sdl3_mixer
	${ELEVATE} pkg install --yes sdl3_shadercross 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		glfw-devel \
		SDL3-devel \
		SDL3_image-devel \
		SDL3_ttf-devel \
		SDL3_net-devel
	${ELEVATE} dnf install --assumeyes SDL3_mixer-devel 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		libglfw3-dev \
		libsdl3-dev \
		libsdl3-image-dev \
		libsdl3-net-dev \
		libsdl3-ttf-dev \
		libsdl3-mixer-dev
	${ELEVATE} apt-get install --yes libsdl3-shadercross-dev 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-glfw \
			mingw-w64-ucrt-x86_64-sdl3 \
			mingw-w64-ucrt-x86_64-sdl3-image \
			mingw-w64-ucrt-x86_64-sdl3-mixer \
			mingw-w64-ucrt-x86_64-sdl3-net \
			mingw-w64-ucrt-x86_64-sdl3-ttf
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			glfw \
			sdl3 \
			sdl3_image
		if command -v yay > "/dev/null" 2>&1; then
			yay -S --needed --noconfirm \
				sdl3_net \
				sdl3_ttf-git \
				sdl3_mixer-git \
				sdl3_shadercross-git 2> "/dev/null" || true
		fi
	fi
elif command -v vcpkg > "/dev/null" 2>&1; then
	vcpkg install glfw3 sdl3 sdl3-image sdl3-mixer sdl3-ttf sdl3-net sdl3-shadercross --triplet x64-windows 2> "/dev/null" || true
else
	echo "❌ [Windowing]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Windowing]: GLFW e ecossistema SDL3 instalados com sucesso!"
