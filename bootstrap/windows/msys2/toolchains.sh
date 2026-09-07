#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 Native Compilers & Build Toolchains (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 Toolchains]: Instalando GCC, Clang, LLVM, NASM e AVR (UCRT64)..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-toolchain \
	mingw-w64-ucrt-x86_64-binutils \
	mingw-w64-ucrt-x86_64-ntldd \
	mingw-w64-ucrt-x86_64-cmake \
	mingw-w64-ucrt-x86_64-ninja \
	mingw-w64-ucrt-x86_64-meson \
	mingw-w64-ucrt-x86_64-clang \
	mingw-w64-ucrt-x86_64-clang-analyzer \
	mingw-w64-ucrt-x86_64-clang-tools-extra \
	mingw-w64-ucrt-x86_64-clang-libs \
	mingw-w64-ucrt-x86_64-lldb \
	mingw-w64-ucrt-x86_64-avr-toolchain \
	mingw-w64-ucrt-x86_64-avr-binutils \
	mingw-w64-ucrt-x86_64-avrdude \
	mingw-w64-ucrt-x86_64-nasm \
	mingw-w64-ucrt-x86_64-asm-lsp

echo "✅ [MSYS2 Toolchains]: Compiladores e ferramentas de build instalados com sucesso!"
