#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: MSYS2 Native Compilers & Build Toolchains (UCRT64)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"

_ui_step "Instalando GCC, Clang, LLVM, NASM e AVR (MSYS2 UCRT64)..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-toolchain \
	mingw-w64-ucrt-x86_64-binutils \
	mingw-w64-ucrt-x86_64-ntldd \
	mingw-w64-ucrt-x86_64-cmake \
	mingw-w64-ucrt-x86_64-cmake-gui \
	mingw-w64-ucrt-x86_64-ninja \
	mingw-w64-ucrt-x86_64-meson \
	mingw-w64-ucrt-x86_64-clang \
	mingw-w64-ucrt-x86_64-clang-analyzer \
	mingw-w64-ucrt-x86_64-clang-tools-extra \
	mingw-w64-ucrt-x86_64-clang-libs \
	mingw-w64-ucrt-x86_64-lldb \
	mingw-w64-ucrt-x86_64-emscripten \
	mingw-w64-ucrt-x86_64-avr-toolchain \
	mingw-w64-ucrt-x86_64-avr-binutils \
	mingw-w64-ucrt-x86_64-avrdude \
	mingw-w64-ucrt-x86_64-nasm \
	mingw-w64-ucrt-x86_64-asm-lsp

_ui_ok "Compiladores e ferramentas de build MSYS2 instalados com sucesso!"
