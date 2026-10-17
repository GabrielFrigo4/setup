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
### Configuração do Cursor em Bloco
### --------------------------------
_ui_sub "Configurando cursor em bloco padrão no console Linux (vt.cur_default=6)..."

if [ -f "/etc/default/grub" ]; then
	if ! grep -q "vt\.cur_default=" "/etc/default/grub" 2> "/dev/null"; then
		if grep -q "^[[:space:]]*GRUB_CMDLINE_LINUX=" "/etc/default/grub" 2> "/dev/null"; then
			${ELEVATE} sed -i 's|^[[:space:]]*GRUB_CMDLINE_LINUX="\(.*\)"|GRUB_CMDLINE_LINUX="\1 vt.cur_default=6"|' "/etc/default/grub"
		elif grep -q "^[[:space:]]*GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" 2> "/dev/null"; then
			${ELEVATE} sed -i 's|^[[:space:]]*GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"|GRUB_CMDLINE_LINUX_DEFAULT="\1 vt.cur_default=6"|' "/etc/default/grub"
		fi
	fi

	if grep -q '^[[:space:]]*GRUB_TERMINAL_OUTPUT="console"' "/etc/default/grub" 2> "/dev/null"; then
		${ELEVATE} sed -i 's|^[[:space:]]*GRUB_TERMINAL_OUTPUT="console"|GRUB_TERMINAL_OUTPUT="gfxterm"|' "/etc/default/grub"
	fi

	if ! grep -q "^[[:space:]]*GRUB_GFXMODE=" "/etc/default/grub" 2> "/dev/null"; then
		echo 'GRUB_GFXMODE="1920x1080,auto"' | ${ELEVATE} tee -a "/etc/default/grub" > "/dev/null"
	fi
	if ! grep -q "^[[:space:]]*GRUB_GFXPAYLOAD_LINUX=" "/etc/default/grub" 2> "/dev/null"; then
		echo 'GRUB_GFXPAYLOAD_LINUX="keep"' | ${ELEVATE} tee -a "/etc/default/grub" > "/dev/null"
	fi

	if command -v grubby > "/dev/null" 2>&1; then
		${ELEVATE} grubby --update-kernel=ALL --args="vt.cur_default=6" 2> "/dev/null" || true
	fi

	if [ -f "/boot/grub2/grub.cfg" ] && command -v grub2-mkconfig > "/dev/null" 2>&1; then
		${ELEVATE} grub2-mkconfig -o /boot/grub2/grub.cfg 2> "/dev/null" || true
	elif command -v update-grub > "/dev/null" 2>&1; then
		${ELEVATE} update-grub 2> "/dev/null" || true
	fi
fi

if [ -d "/etc/tmpfiles.d" ]; then
	echo "w /sys/class/graphics/fbcon/cursor_blink - - - - 0" | ${ELEVATE} tee "/etc/tmpfiles.d/console-cursor.conf" > "/dev/null"
fi
if [ -f "/sys/class/graphics/fbcon/cursor_blink" ]; then
	echo 0 | ${ELEVATE} tee /sys/class/graphics/fbcon/cursor_blink > "/dev/null" 2>&1 || true
fi
if command -v systemctl > "/dev/null" 2>&1; then
	_getty_dropin_dir="/etc/systemd/system/getty@.service.d"
	[ -d "${_getty_dropin_dir}" ] || ${ELEVATE} mkdir -p "${_getty_dropin_dir}"
	cat <<- "EOF" | ${ELEVATE} tee "${_getty_dropin_dir}/utf8.conf" > "/dev/null"
	[Service]
	Environment=LANG=pt_BR.UTF-8
	TTYVTDisallocate=no
	ExecStartPre=-/usr/lib/systemd/systemd-vconsole-setup /dev/%I
	ExecStart=
	ExecStart=-/usr/sbin/agetty --8bits --noreset --noclear --issue-file=/etc/issue:/etc/issue.d:/run/issue.d:/usr/lib/issue.d - $TERM
	EOF
	${ELEVATE} systemctl daemon-reload 2> "/dev/null" || true
fi

if [ -f "/etc/issue" ]; then
	_tmp_issue="$(mktemp)"
	printf '\033%%G\033[?6c' > "${_tmp_issue}"
	sed -e 's/\x1b%G//g' -e 's/\x1b\[?6c//g' -e 's/\x1b\[16;[0-9]*\]//g' "/etc/issue" >> "${_tmp_issue}"
	${ELEVATE} cp "${_tmp_issue}" "/etc/issue"
	${ELEVATE} chmod 0644 "/etc/issue"
	rm -f "${_tmp_issue}"
fi

### --------------------------------
### Descoberta Dinâmica de Consoles
### --------------------------------
_vts="/dev/tty0"

for _t in $(ps -e -o tty= 2> "/dev/null" | sort -u | grep -E '^tty[0-9]+$'); do
	_vts="${_vts} /dev/${_t}"
done

if command -v systemctl > "/dev/null" 2>&1; then
	for _unit in $(systemctl list-units --type=service 'getty@*' 'autovt@*' --no-legend --no-pager 2> "/dev/null" | awk '{print $1}'); do
		_t="$(echo "${_unit}" | sed -E 's/^(getty|autovt)@([^.]+)\.service$/\2/')"
		case "${_t}" in
			tty[0-9]*) _vts="${_vts} /dev/${_t}" ;;
		esac
	done
fi

for _i in 1 2 3 4 5 6; do
	_vts="${_vts} /dev/tty${_i}"
done

_unique_vts="$(echo "${_vts}" | tr ' ' '\n' | sort -u)"

for _c in ${_unique_vts}; do
	if [ -c "${_c}" ]; then
		printf '\033%%G\033[?6c' | ${ELEVATE} tee "${_c}" > "/dev/null" 2>&1 || true
		command -v stty > "/dev/null" 2>&1 && ${ELEVATE} stty -F "${_c}" iutf8 2> "/dev/null" || true
	fi
done

### --------------------------------
### Ativação Imediata da Fonte
### --------------------------------
if command -v setfont > "/dev/null" 2>&1; then
	${ELEVATE} setfont "${_target_font}" 2> "/dev/null" || true
	for _c in ${_unique_vts}; do
		if [ -c "${_c}" ] && [ "${_c}" != "/dev/tty0" ]; then
			${ELEVATE} setfont -C "${_c}" "${_target_font}" 2> "/dev/null" || true
		fi
	done
fi

if command -v systemctl > "/dev/null" 2>&1 && systemctl is-active --quiet systemd-vconsole-setup.service 2> "/dev/null"; then
	${ELEVATE} systemctl restart systemd-vconsole-setup.service 2> "/dev/null" || true
fi

_ui_ok "Console TTY configurado com sucesso (fonte ${_target_font} e cursor em bloco)!"
