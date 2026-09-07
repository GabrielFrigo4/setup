#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Virtualization (KVM, QEMU & Libvirt)
# ------------------------------------------------------------------------------
set -eu

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

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
