#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: LibreSprite Dependencies Build
# ------------------------------------------------------------------------------
set -eu

echo "📦 [LibreSprite]: Instalando dependências de compilação..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-freetype \
	mingw-w64-ucrt-x86_64-giflib \
	mingw-w64-ucrt-x86_64-libjpeg-turbo \
	mingw-w64-ucrt-x86_64-libpng \
	mingw-w64-ucrt-x86_64-libwebp \
	mingw-w64-ucrt-x86_64-pixman \
	mingw-w64-ucrt-x86_64-SDL2 \
	mingw-w64-ucrt-x86_64-SDL2_image \
	mingw-w64-ucrt-x86_64-tinyxml2 \
	mingw-w64-ucrt-x86_64-v8 \
	mingw-w64-ucrt-x86_64-zlib \
	mingw-w64-ucrt-x86_64-libarchive

echo "✅ [LibreSprite]: Dependências instaladas com sucesso!"
