#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux CLI Tools & Static Analysis
# ------------------------------------------------------------------------------
set -eu

yay -S --needed --noconfirm \
	fd \
	bat \
	eza \
	grex \
	ripgrep \
	repgrep \
	fastfetch \
	imagemagick \
	ffmpeg \
	yt-dlp \
	pandoc-cli \
	poppler \
	graphviz \
	tesseract \
	tesseract-data-eng \
	tesseract-data-por \
	ocrmypdf

yay -S --needed --noconfirm \
	xelfviewer-bin \
	xpeviewer-bin \
	xmachoviewer-bin \
	xapkdetector-bin \
	ghidra \
	gf2-git \
	valgrind \
	lldb \
	strace \
	ltrace \
	radare2
