#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Arch Linux Server & VM Management Scripts
# ------------------------------------------------------------------------------
set -eu

if [ -n "${FRIGO_SERVER_KEY-}" ] && [ -f "${FRIGO_SERVER_KEY}" ]; then
	chmod 0600 "${FRIGO_SERVER_KEY}"
fi

if [ -n "${ORBS_SERVER_KEY-}" ] && [ -f "${ORBS_SERVER_KEY}" ]; then
	chmod 0600 "${ORBS_SERVER_KEY}"
fi

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-start" > "/dev/null"
#!/usr/bin/env sh
virsh --connect "qemu:///system" start FreeBSD
EOF
sudo chmod 0755 "/usr/local/bin/freebsd-start"

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-close" > "/dev/null"
#!/usr/bin/env sh
virsh --connect "qemu:///system" destroy FreeBSD
EOF
sudo chmod 0755 "/usr/local/bin/freebsd-close"

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-restart" > "/dev/null"
#!/usr/bin/env sh
virsh --connect "qemu:///system" reboot FreeBSD
EOF
sudo chmod 0755 "/usr/local/bin/freebsd-restart"

cat << 'EOF' | sudo tee "/usr/local/bin/freebsd-server" > "/dev/null"
#!/usr/bin/env sh
FREEBSD_IP="$(virsh --connect "qemu:///system" domifaddr FreeBSD 2> "/dev/null" | awk '$3 == "ipv4" {print $4}' | cut -d'/' -f1 || true)"
if [ -z "${FREEBSD_IP}" ]; then
	echo "❌ Não foi possível detectar o IP da VM FreeBSD."
	exit 1
fi
ssh "freebsd@${FREEBSD_IP}"
EOF
sudo chmod 0755 "/usr/local/bin/freebsd-server"

echo "✅ [Arch Servers]: Utilitários de controle da VM FreeBSD instalados em /usr/local/bin!"
