#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Media Processing Tools (FFmpeg, ImageMagick)
# ----------------------------------------------------------------
set -eu

echo "📦 [Media]: Instalando FFmpeg, ImageMagick e yt-dlp..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		ffmpeg \
		ImageMagick7 \
		yt-dlp
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
	echo "❌ [Media]: Gerenciador de pacotes não suportado." >&2
	exit 1
fi

echo "✅ [Media]: FFmpeg, ImageMagick e yt-dlp instalados com sucesso!"
