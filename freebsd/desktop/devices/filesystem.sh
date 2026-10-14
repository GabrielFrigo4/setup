#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Modern Filesystems & FUSE
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Instalando drivers de sistemas de arquivos..."

${ELEVATE} pkg install --yes sysutils/fusefs-exfat sysutils/exfat-utils sysutils/fusefs-ntfs sysutils/fusefs-ext2
if ! sysrc -n kld_list 2> "/dev/null" | grep -q "fusefs"; then
	${ELEVATE} sysrc kld_list+="fusefs"
fi
${ELEVATE} kldload fusefs 2> "/dev/null" || true

_ui_ok "Drivers FUSE instalados e módulo carregado!"
