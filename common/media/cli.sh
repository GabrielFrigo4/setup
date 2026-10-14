#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Media Processing Tools (FFmpeg, ImageMagick)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v ffmpeg > "/dev/null" 2>&1 && { command -v magick > "/dev/null" 2>&1 || command -v convert > "/dev/null" 2>&1; }; then
	_ui_ok "Ferramentas de mídia (FFmpeg, ImageMagick) já instaladas."
	exit 0
fi

_ui_step "Instalando FFmpeg, ImageMagick e yt-dlp..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		multimedia/ffmpeg \
		graphics/ImageMagick7 \
		www/yt-dlp
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		ffmpeg \
		ImageMagick \
		yt-dlp 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		ffmpeg \
		imagemagick \
		yt-dlp 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-ffmpeg \
			mingw-w64-ucrt-x86_64-imagemagick
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			ffmpeg \
			imagemagick \
			yt-dlp
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Gyan.FFmpeg --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id ImageMagick.ImageMagick --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id yt-dlp.yt-dlp --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "FFmpeg, ImageMagick e yt-dlp instalados com sucesso!"
