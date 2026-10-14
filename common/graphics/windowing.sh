#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Windowing & Multimedia Libraries (GLFW & SDL3)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v pkg-config > "/dev/null" 2>&1 && pkg-config --exists glfw3 sdl3 2> "/dev/null"; then
	_ui_ok "Bibliotecas de janelamento (GLFW e SDL3) já instaladas."
	exit 0
fi

_ui_step "Instalando GLFW e ecossistema SDL3..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		graphics/glfw \
		devel/sdl3 \
		graphics/sdl3_image \
		net/sdl3_net \
		graphics/sdl3_ttf \
		audio/sdl3_mixer
	${ELEVATE} pkg install --yes graphics/sdl3_shadercross 2> "/dev/null" || true
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
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "GLFW e ecossistema SDL3 instalados com sucesso!"
