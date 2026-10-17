#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal TTY Console Spleen Font
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando fonte Spleen 16x32 para console TTY Linux..."

_target_font="spleen-16x32"
_spleen_version="2.2.0"

_font_found=0
for _console_dir in "/usr/lib/kbd/consolefonts" "/usr/share/kbd/consolefonts" "/usr/share/consolefonts"; do
	if [ -f "${_console_dir}/${_target_font}.psfu" ] || [ -f "${_console_dir}/${_target_font}.psfu.gz" ] || [ -f "${_console_dir}/${_target_font}.psf.gz" ]; then
		_font_found=1
		break
	fi
done

if [ "${_font_found}" -eq 0 ]; then
	_ui_sub "Baixando fontes Spleen para console..."
	_tmp_dir="$(mktemp -d)"
	_archive="${_tmp_dir}/spleen.tar.gz"

	curl -fsSL -o "${_archive}" "https://github.com/fcambus/spleen/releases/download/${_spleen_version}/spleen-${_spleen_version}.tar.gz"
	tar -xzf "${_archive}" -C "${_tmp_dir}"

	_primary_dir="/usr/lib/kbd/consolefonts"
	[ -d "${_primary_dir}" ] || _primary_dir="/usr/share/kbd/consolefonts"
	[ -d "${_primary_dir}" ] || _primary_dir="/usr/share/consolefonts"

	if [ ! -d "${_primary_dir}" ]; then
		${ELEVATE} mkdir -p "${_primary_dir}"
	fi

	${ELEVATE} cp "${_tmp_dir}/spleen-${_spleen_version}"/spleen-*.psfu "${_primary_dir}/"
	${ELEVATE} chmod 0644 "${_primary_dir}"/spleen-*.psfu

	for _extra_dir in "/usr/lib/kbd/consolefonts" "/usr/share/kbd/consolefonts" "/usr/share/consolefonts"; do
		if [ -d "${_extra_dir}" ] && [ "${_extra_dir}" != "${_primary_dir}" ]; then
			${ELEVATE} cp "${_tmp_dir}/spleen-${_spleen_version}"/spleen-*.psfu "${_extra_dir}/"
			${ELEVATE} chmod 0644 "${_extra_dir}"/spleen-*.psfu
		fi
	done

	rm -rf "${_tmp_dir}"
fi

### --------------------------------
### Configuração vconsole.conf
### --------------------------------
if [ -f "/etc/vconsole.conf" ]; then
	if grep -q "^[[:space:]]*FONT=" "/etc/vconsole.conf" 2> "/dev/null"; then
		${ELEVATE} sed -i "s|^[[:space:]]*FONT=.*|FONT=\"${_target_font}\"|" "/etc/vconsole.conf"
	else
		echo "FONT=\"${_target_font}\"" | ${ELEVATE} tee -a "/etc/vconsole.conf" > "/dev/null"
	fi
else
	echo "FONT=\"${_target_font}\"" | ${ELEVATE} tee "/etc/vconsole.conf" > "/dev/null"
fi

### --------------------------------
### Configuração console-setup
### --------------------------------
if [ -f "/etc/default/console-setup" ]; then
	if grep -q "^[[:space:]]*FONTFACE=" "/etc/default/console-setup" 2> "/dev/null"; then
		${ELEVATE} sed -i 's|^[[:space:]]*FONTFACE=.*|FONTFACE="Spleen"|' "/etc/default/console-setup"
		${ELEVATE} sed -i 's|^[[:space:]]*FONTSIZE=.*|FONTSIZE="16x32"|' "/etc/default/console-setup"
	fi
	if command -v setupcon > "/dev/null" 2>&1; then
		${ELEVATE} setupcon --save 2> "/dev/null" || true
	fi
fi

### --------------------------------
### Ativação Imediata da Fonte
### --------------------------------
if command -v setfont > "/dev/null" 2>&1; then
	${ELEVATE} setfont "${_target_font}" 2> "/dev/null" || true
fi

if command -v systemctl > "/dev/null" 2>&1 && systemctl is-active --quiet systemd-vconsole-setup.service 2> "/dev/null"; then
	${ELEVATE} systemctl restart systemd-vconsole-setup.service 2> "/dev/null" || true
fi

_ui_ok "Fonte do console TTY configurada com sucesso (${_target_font})!"
