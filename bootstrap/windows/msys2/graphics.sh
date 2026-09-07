#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 GUI Frameworks & Game Development Libraries (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 Graphics]: Instalando GTK, Qt, Raylib, SDL2, SDL3 e Vulkan..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-glib2 \
	mingw-w64-ucrt-x86_64-cairo \
	mingw-w64-ucrt-x86_64-pango \
	mingw-w64-ucrt-x86_64-gtk3 \
	mingw-w64-ucrt-x86_64-gtk4 \
	mingw-w64-ucrt-x86_64-qt5 \
	mingw-w64-ucrt-x86_64-qt6 \
	mingw-w64-ucrt-x86_64-SDL2 \
	mingw-w64-ucrt-x86_64-SDL2_image \
	mingw-w64-ucrt-x86_64-SDL2_mixer \
	mingw-w64-ucrt-x86_64-SDL2_ttf \
	mingw-w64-ucrt-x86_64-sdl3 \
	mingw-w64-ucrt-x86_64-sdl3-image \
	mingw-w64-ucrt-x86_64-sdl3-ttf \
	mingw-w64-ucrt-x86_64-raylib \
	mingw-w64-ucrt-x86_64-sfml \
	mingw-w64-ucrt-x86_64-glfw \
	mingw-w64-ucrt-x86_64-vulkan-devel \
	mingw-w64-ucrt-x86_64-glm \
	mingw-w64-ucrt-x86_64-glew \
	mingw-w64-ucrt-x86_64-openal \
	mingw-w64-ucrt-x86_64-miniaudio \
	mingw-w64-ucrt-x86_64-stb

echo "✅ [MSYS2 Graphics]: Bibliotecas gráficas e multimídia instaladas com sucesso!"
