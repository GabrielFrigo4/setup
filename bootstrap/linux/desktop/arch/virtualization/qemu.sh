#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Virtualization (KVM, QEMU & Libvirt)
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Arch QEMU]: Configurando virtualização (KVM, QEMU e Libvirt)..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

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

echo "✅ [Arch QEMU]: Virtualização configurada com sucesso!"
