#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Fedora GameDev & Graphics Libraries
# ----------------------------------------------------------------
set -eu

echo "📦 [Fedora GameDev]: Instalando GLFW, SDL3 e bibliotecas de desenvolvimento..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} dnf install --assumeyes \
	glfw-devel \
	SDL3-devel \
	SDL3_image-devel \
	SDL3_ttf-devel \
	SDL3_net-devel \
	spirv-cross-devel

${ELEVATE} dnf install --assumeyes SDL3_mixer-devel 2> "/dev/null" || true
${ELEVATE} dnf install --assumeyes emscripten 2> "/dev/null" || true

echo "✅ [Fedora GameDev]: Bibliotecas e ferramentas instaladas com sucesso!"
