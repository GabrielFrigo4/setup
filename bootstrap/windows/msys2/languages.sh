#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: MSYS2 Programming Languages (Python, Lua, Rust) (UCRT64)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [MSYS2 Languages]: Instalando runtimes de Python, Lua e Rust..."

pacman --needed --noconfirm -S \
	mingw-w64-ucrt-x86_64-python \
	mingw-w64-ucrt-x86_64-python-pip \
	mingw-w64-ucrt-x86_64-python-pipx \
	mingw-w64-ucrt-x86_64-uv \
	mingw-w64-ucrt-x86_64-cython \
	mingw-w64-ucrt-x86_64-mypy \
	mingw-w64-ucrt-x86_64-python-capstone \
	mingw-w64-ucrt-x86_64-python-unicorn \
	mingw-w64-ucrt-x86_64-python-cryptography \
	mingw-w64-ucrt-x86_64-python-pynacl \
	mingw-w64-ucrt-x86_64-python-cffi \
	mingw-w64-ucrt-x86_64-python-pywin32 \
	mingw-w64-ucrt-x86_64-python-psutil \
	mingw-w64-ucrt-x86_64-python-zstandard \
	mingw-w64-ucrt-x86_64-lua \
	mingw-w64-ucrt-x86_64-luajit \
	mingw-w64-ucrt-x86_64-lua-luarocks \
	mingw-w64-ucrt-x86_64-rustup \
	mingw-w64-ucrt-x86_64-rust-analyzer

python -m pip install --break-system-packages \
	six \
	python-dateutil \
	sortedcontainers \
	intervaltree \
	PySocks \
	requests \
	pyserial \
	paramiko \
	pyelftools \
	unix-ar \
	mako \
	colored-traceback \
	weasyprint 2> "/dev/null" || true

luarocks install lua-cjson 2> "/dev/null" || true
luarocks install luafilesystem 2> "/dev/null" || true
luarocks install luasocket 2> "/dev/null" || true
luarocks install cffi-lua 2> "/dev/null" || true
luarocks install lpeg 2> "/dev/null" || true
luarocks install penlight 2> "/dev/null" || true

rustup default stable 2> "/dev/null" || true

echo "✅ [MSYS2 Languages]: Ambientes de linguagem configurados com sucesso!"
