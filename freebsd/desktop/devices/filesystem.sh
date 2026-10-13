#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Modern Filesystems & FUSE
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Filesystems]: Instalando drivers de sistemas de arquivos..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pkg install --yes sysutils/fusefs-exfat sysutils/exfat-utils sysutils/fusefs-ntfs sysutils/fusefs-ext2
${ELEVATE} sysrc kld_list+="fusefs"
${ELEVATE} kldload fusefs 2> "/dev/null" || true

echo "✅ [FreeBSD Filesystems]: Drivers FUSE instalados e módulo carregado!"
