#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Rust Toolchain & EWM Wayland Build Dependencies
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v cargo > "/dev/null" 2>&1 && command -v rustc > "/dev/null" 2>&1 && command -v pkg-config > "/dev/null" 2>&1 && pkg-config --exists libinput libxkbcommon pixman-1 2> "/dev/null"; then
	_ui_ok "Toolchain Rust e dependências de compilação do EWM já instaladas."
	exit 0
fi

_ui_step "Instalando toolchain Rust e dependências de baixo nível para EWM..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		lang/rust \
		devel/cargo \
		devel/pkgconf \
		x11/libxkbcommon \
		x11/libinput \
		x11/pixman \
		graphics/mesa-libs \
		misc/hwdata
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		cargo \
		rust \
		pkgconf \
		libinput-devel \
		libxkbcommon-devel \
		pixman-devel \
		mesa-libgbm-devel \
		hwdata
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		cargo \
		rustc \
		pkg-config \
		libinput-dev \
		libxkbcommon-dev \
		libpixman-1-dev \
		libgbm-dev \
		hwdata 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		cargo \
		rust \
		pkgconf \
		libinput \
		libxkbcommon \
		pixman \
		mesa \
		hwdata
else
	_ui_err "Gerenciador de pacotes não suportado para toolchain Rust/EWM."
	exit 1
fi

_ui_ok "Toolchain Rust e dependências do EWM instaladas com sucesso!"
