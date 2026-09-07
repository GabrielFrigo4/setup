#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 Native System & Runtime Libraries (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 Libraries]: Instalando bibliotecas nativas de sistema e runtime..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-gcc-libs \
	mingw-w64-ucrt-x86_64-compiler-rt \
	mingw-w64-ucrt-x86_64-libunwind \
	mingw-w64-ucrt-x86_64-libc++ \
	mingw-w64-ucrt-x86_64-llvm-openmp \
	mingw-w64-ucrt-x86_64-libwinpthread \
	mingw-w64-ucrt-x86_64-libuv \
	mingw-w64-ucrt-x86_64-zlib \
	mingw-w64-ucrt-x86_64-zstd \
	mingw-w64-ucrt-x86_64-openssl \
	mingw-w64-ucrt-x86_64-libsodium \
	mingw-w64-ucrt-x86_64-libusb \
	mingw-w64-ucrt-x86_64-hidapi \
	mingw-w64-ucrt-x86_64-zeromq \
	mingw-w64-ucrt-x86_64-libarchive \
	mingw-w64-ucrt-x86_64-sqlite3 \
	mingw-w64-ucrt-x86_64-tree-sitter

echo "✅ [MSYS2 Libraries]: Bibliotecas de sistema instaladas com sucesso!"
