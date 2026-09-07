#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Modern Filesystems & FUSE
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Filesystems]: Instalando drivers de sistemas de arquivos..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes fusefs-exfat exfat-utils fusefs-ntfs fusefs-ext2
${ELEVATE} sysrc kld_list+="fusefs"
${ELEVATE} kldload fusefs 2> "/dev/null" || true

echo "✅ [FreeBSD Filesystems]: Drivers FUSE instalados e módulo carregado!"
