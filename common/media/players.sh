#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common Media Players (MPV, VLC & yt-dlp)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v mpv > "/dev/null" 2>&1 && command -v vlc > "/dev/null" 2>&1 && command -v yt-dlp > "/dev/null" 2>&1; then
	_ui_ok "Players de mídia (MPV, VLC e yt-dlp) já instalados."
	exit 0
fi

_ui_step "Instalando players de mídia (MPV, VLC e yt-dlp)..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		multimedia/mpv \
		multimedia/vlc \
		www/yt-dlp
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		mpv \
		vlc \
		yt-dlp
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		mpv \
		vlc \
		yt-dlp 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman -S --needed --noconfirm \
		mpv \
		vlc \
		yt-dlp
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id VideoLAN.VLC --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id shinchiro.mpv --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id yt-dlp.yt-dlp --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
else
	_ui_err "Gerenciador de pacotes não suportado para instalação de players de mídia."
	exit 1
fi

_ui_ok "Players de mídia (MPV, VLC e yt-dlp) instalados com sucesso!"
