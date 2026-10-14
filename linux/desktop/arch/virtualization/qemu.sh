#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Virtualization (KVM, QEMU & Libvirt)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando virtualização (KVM, QEMU e Libvirt)..."

TARGET_USER="${DOAS_USER:-${SUDO_USER:-$(id -un)}}"

${ELEVATE} pacman -S --needed --noconfirm \
	qemu-desktop \
	libvirt \
	dnsmasq \
	iptables-nft \
	edk2-ovmf \
	virt-manager \
	virt-viewer

${ELEVATE} systemctl enable --now libvirtd 2> "/dev/null" || true
${ELEVATE} usermod --append --groups libvirt "${TARGET_USER}" 2> "/dev/null" || true
${ELEVATE} virsh --connect qemu:///system net-autostart default 2> "/dev/null" || true
${ELEVATE} virsh --connect qemu:///system net-start default 2> "/dev/null" || true

_ui_ok "Virtualização configurada com sucesso!"
