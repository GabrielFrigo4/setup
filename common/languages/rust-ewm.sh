#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Rust Toolchain & EWM Wayland Build Dependencies
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v cargo > "/dev/null" 2>&1 && command -v rustc > "/dev/null" 2>&1 && command -v pkg-config > "/dev/null" 2>&1 && pkg-config --exists libinput pixman-1 gbm wayland-server glib-2.0 libdisplay-info 2> "/dev/null" && (pkg-config --exists xkbcommon 2> "/dev/null" || pkg-config --exists libxkbcommon 2> "/dev/null"); then
	_ui_ok "Toolchain Rust e dependências de compilação do EWM já instaladas."
	exit 0
fi

_ui_step "Instalando toolchain Rust e dependências de baixo nível para EWM..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		lang/rust \
		devel/pkgconf \
		devel/libffi \
		devel/glib20 \
		sysutils/libdisplay-info \
		x11/libxkbcommon \
		x11/libinput \
		x11/pixman \
		graphics/wayland \
		graphics/wayland-protocols \
		graphics/mesa-libs \
		sysutils/seatd \
		misc/hwdata
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		cargo \
		rust \
		pkgconf \
		libffi-devel \
		glib2-devel \
		libdisplay-info-devel \
		libinput-devel \
		libxkbcommon-devel \
		pixman-devel \
		mesa-libgbm-devel \
		wayland-devel \
		wayland-protocols-devel \
		libseat-devel \
		hwdata
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		cargo \
		rustc \
		pkg-config \
		libffi-dev \
		libglib2.0-dev \
		libdisplay-info-dev \
		libinput-dev \
		libxkbcommon-dev \
		libpixman-1-dev \
		libgbm-dev \
		libwayland-dev \
		wayland-protocols \
		libseat-dev \
		hwdata 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		cargo \
		rust \
		pkgconf \
		libffi \
		glib2 \
		libdisplay-info \
		libinput \
		libxkbcommon \
		pixman \
		mesa \
		wayland \
		wayland-protocols \
		seatd \
		hwdata
else
	_ui_err "Gerenciador de pacotes não suportado para toolchain Rust/EWM."
	exit 1
fi

_ui_ok "Toolchain Rust e dependências do EWM instaladas com sucesso!"
