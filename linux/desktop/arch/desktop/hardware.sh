#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Hardware Video Acceleration & Udev Rules
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando aceleração gráfica e regras udev..."

${ELEVATE} pacman -S --needed --noconfirm \
	mesa \
	vulkan-devel \
	intel-media-driver \
	libva-intel-driver \
	libva-utils \
	libva

curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules | ${ELEVATE} tee /etc/udev/rules.d/99-platformio-udev.rules > "/dev/null" 2>&1 || true

cat << 'EOF' | ${ELEVATE} tee "/etc/udev/rules.d/99-ds4.rules" > "/dev/null"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
EOF

${ELEVATE} udevadm control --reload-rules 2> "/dev/null" || true
${ELEVATE} udevadm trigger 2> "/dev/null" || true

_ui_ok "Hardware e regras configurados com sucesso!"
