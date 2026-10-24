#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal TTY Console Spleen Font
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando fonte Spleen 12x24 para console TTY Linux..."

_target_font="spleen-12x24"
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
		${ELEVATE} sed -i 's|^[[:space:]]*FONTSIZE=.*|FONTSIZE="12x24"|' "/etc/default/console-setup"
	fi
	if command -v setupcon > "/dev/null" 2>&1; then
		${ELEVATE} setupcon --save 2> "/dev/null" || true
	fi
fi

### --------------------------------
### Configuração do Cursor em Bloco
### --------------------------------
_ui_sub "Configurando cursor em bloco padrão no console Linux (vt.cur_default=0xee10)..."

if [ -f "/etc/default/grub" ]; then
	if ! grep -q "vt\.cur_default=" "/etc/default/grub" 2> "/dev/null"; then
		if grep -q "^[[:space:]]*GRUB_CMDLINE_LINUX=" "/etc/default/grub" 2> "/dev/null"; then
			${ELEVATE} sed -i 's|^[[:space:]]*GRUB_CMDLINE_LINUX="\(.*\)"|GRUB_CMDLINE_LINUX="\1 vt.cur_default=0xee10"|' "/etc/default/grub"
		elif grep -q "^[[:space:]]*GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" 2> "/dev/null"; then
			${ELEVATE} sed -i 's|^[[:space:]]*GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"|GRUB_CMDLINE_LINUX_DEFAULT="\1 vt.cur_default=0xee10"|' "/etc/default/grub"
		fi
	fi

	if grep -q '^[[:space:]]*GRUB_TERMINAL_OUTPUT="console"' "/etc/default/grub" 2> "/dev/null"; then
		${ELEVATE} sed -i 's|^[[:space:]]*GRUB_TERMINAL_OUTPUT="console"|GRUB_TERMINAL_OUTPUT="gfxterm"|' "/etc/default/grub"
	fi

	if grep -q "^[[:space:]]*GRUB_GFXMODE=" "/etc/default/grub" 2> "/dev/null"; then
		${ELEVATE} sed -i 's|^[[:space:]]*GRUB_GFXMODE=.*|GRUB_GFXMODE="auto"|' "/etc/default/grub"
	else
		echo 'GRUB_GFXMODE="auto"' | ${ELEVATE} tee -a "/etc/default/grub" > "/dev/null"
	fi
	if ! grep -q "^[[:space:]]*GRUB_GFXPAYLOAD_LINUX=" "/etc/default/grub" 2> "/dev/null"; then
		echo 'GRUB_GFXPAYLOAD_LINUX="keep"' | ${ELEVATE} tee -a "/etc/default/grub" > "/dev/null"
	fi

	if command -v grubby > "/dev/null" 2>&1; then
		${ELEVATE} grubby --update-kernel=ALL --args="vt.cur_default=0xee10" 2> "/dev/null" || true
	fi

	if [ -f "/boot/grub2/grub.cfg" ] && command -v grub2-mkconfig > "/dev/null" 2>&1; then
		${ELEVATE} grub2-mkconfig -o /boot/grub2/grub.cfg 2> "/dev/null" || true
	elif command -v update-grub > "/dev/null" 2>&1; then
		${ELEVATE} update-grub 2> "/dev/null" || true
	fi
fi

if [ -d "/etc/tmpfiles.d" ]; then
	cat <<- "EOF" | ${ELEVATE} tee "/etc/tmpfiles.d/console-cursor.conf" > "/dev/null"
	w /sys/module/vt/parameters/cur_default - - - - 60944
	w /sys/class/graphics/fbcon/cursor_blink - - - - 0
	w /sys/module/vt/parameters/default_red - - - - 0,209,115,229,86,197,78,212,133,247,158,224,125,187,79,255
	w /sys/module/vt/parameters/default_grn - - - - 0,105,201,192,156,134,201,212,133,118,206,175,207,154,193,255
	w /sys/module/vt/parameters/default_blu - - - - 0,105,145,123,214,192,176,212,133,142,106,104,255,247,255,255
	EOF
fi
if [ -f "/sys/module/vt/parameters/cur_default" ]; then
	echo 60944 | ${ELEVATE} tee /sys/module/vt/parameters/cur_default > "/dev/null" 2>&1 || true
fi
if [ -f "/sys/class/graphics/fbcon/cursor_blink" ]; then
	echo 0 | ${ELEVATE} tee /sys/class/graphics/fbcon/cursor_blink > "/dev/null" 2>&1 || true
fi
if [ -f "/sys/module/vt/parameters/default_red" ]; then
	echo "0,209,115,229,86,197,78,212,133,247,158,224,125,187,79,255" | ${ELEVATE} tee /sys/module/vt/parameters/default_red > "/dev/null" 2>&1 || true
	echo "0,105,201,192,156,134,201,212,133,118,206,175,207,154,193,255" | ${ELEVATE} tee /sys/module/vt/parameters/default_grn > "/dev/null" 2>&1 || true
	echo "0,105,145,123,214,192,176,212,133,142,106,104,255,247,255,255" | ${ELEVATE} tee /sys/module/vt/parameters/default_blu > "/dev/null" 2>&1 || true
fi
### --------------------------------
### Mapeamento Teclas F1-F5
### --------------------------------
_keymap_dir="/usr/local/share/kbd/keymaps"
[ -d "${_keymap_dir}" ] || ${ELEVATE} mkdir -p "${_keymap_dir}"
cat <<- "EOF" | ${ELEVATE} tee "${_keymap_dir}/standard-fkeys.map" > "/dev/null"
string F1 = "\033[11~"
string F2 = "\033[12~"
string F3 = "\033[13~"
string F4 = "\033[14~"
string F5 = "\033[15~"
EOF
${ELEVATE} chmod 0644 "${_keymap_dir}/standard-fkeys.map"

if command -v systemctl > "/dev/null" 2>&1; then
	_getty_dropin_dir="/etc/systemd/system/getty@.service.d"
	[ -d "${_getty_dropin_dir}" ] || ${ELEVATE} mkdir -p "${_getty_dropin_dir}"
	cat <<- "EOF" | ${ELEVATE} tee "${_getty_dropin_dir}/utf8.conf" > "/dev/null"
	[Service]
	Environment=LANG=pt_BR.UTF-8
	TTYVTDisallocate=no
	ExecStartPre=-/usr/lib/systemd/systemd-vconsole-setup /dev/%I
	ExecStartPre=-/usr/bin/loadkeys -C /dev/%I /usr/local/share/kbd/keymaps/standard-fkeys.map
	ExecStart=
	ExecStart=-/usr/sbin/agetty --8bits --noreset --noclear --issue-file=/etc/issue:/etc/issue.d:/run/issue.d:/usr/lib/issue.d - $TERM
	EOF
	${ELEVATE} systemctl daemon-reload 2> "/dev/null" || true
fi

_tty_palette='\033]P0000000\033]P1d16969\033]P273c991\033]P3e5c07b\033]P4569cd6\033]P5c586c0\033]P64ec9b0\033]P7d4d4d4\033]P8858585\033]P9f7768e\033]PA9ece6a\033]PBe0af68\033]PC7dcfff\033]PDbb9af7\033]PE4fc1ff\033]PFffffff'

if [ -f "/etc/issue" ]; then
	_tmp_issue="$(mktemp)"
	printf '\033%%G\033[?16;238;0c%b' "${_tty_palette}" > "${_tmp_issue}"
	sed -e 's/\x1b%G//g' -e 's/\x1b\]P[0-9A-Fa-f]\{7\}//g' -e 's/\x1b\[?6c//g' -e 's/\x1b\[?17;0;[0-9]*c//g' -e 's/\x1b\[?112;0;[0-9]*c//g' -e 's/\x1b\[?112c//g' -e 's/\x1b\[?16;[0-9]*;[0-9]*c//g' -e 's/\x1b\[?0c//g' -e 's/\x1b\[?12l//g' -e 's/\x1b\[16;[0-9]*\]//g' "/etc/issue" >> "${_tmp_issue}"
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
		printf '\033%%G\033[?16;238;0c%b' "${_tty_palette}" | ${ELEVATE} tee "${_c}" > "/dev/null" 2>&1 || true
		command -v stty > "/dev/null" 2>&1 && ${ELEVATE} stty -F "${_c}" iutf8 2> "/dev/null" || true
	fi
done

### --------------------------------
### Ativação Fonte e Teclado
### --------------------------------
if command -v setfont > "/dev/null" 2>&1; then
	${ELEVATE} setfont "${_target_font}" 2> "/dev/null" || true
	for _c in ${_unique_vts}; do
		if [ -c "${_c}" ] && [ "${_c}" != "/dev/tty0" ]; then
			${ELEVATE} setfont -C "${_c}" "${_target_font}" 2> "/dev/null" || true
		fi
	done
fi

if command -v loadkeys > "/dev/null" 2>&1 && [ -f "${_keymap_dir}/standard-fkeys.map" ]; then
	${ELEVATE} loadkeys -C /dev/tty0 "${_keymap_dir}/standard-fkeys.map" 2> "/dev/null" || true
	for _c in ${_unique_vts}; do
		if [ -c "${_c}" ] && [ "${_c}" != "/dev/tty0" ]; then
			${ELEVATE} loadkeys -C "${_c}" "${_keymap_dir}/standard-fkeys.map" 2> "/dev/null" || true
		fi
	done
fi

if command -v systemctl > "/dev/null" 2>&1 && systemctl is-active --quiet systemd-vconsole-setup.service 2> "/dev/null"; then
	${ELEVATE} systemctl restart systemd-vconsole-setup.service 2> "/dev/null" || true
fi

### --------------------------------
### Mouse de Console GPM
### --------------------------------
if ! command -v gpm > "/dev/null" 2>&1; then
	if command -v dnf > "/dev/null" 2>&1; then
		${ELEVATE} dnf install --assumeyes gpm
	elif command -v apt-get > "/dev/null" 2>&1; then
		${ELEVATE} apt-get install --yes gpm 2> "/dev/null" || true
	elif command -v pacman > "/dev/null" 2>&1; then
		${ELEVATE} pacman -S --needed --noconfirm gpm
	fi
fi

if command -v gpm > "/dev/null" 2>&1; then
	[ -f "/etc/sysconfig/gpm" ] && ${ELEVATE} sed -i 's|^APPEND=.*|APPEND="-a 2 -r 100"|' "/etc/sysconfig/gpm" 2> "/dev/null" || true
	if command -v systemctl > "/dev/null" 2>&1; then
		${ELEVATE} systemctl enable --now gpm.service 2> "/dev/null" || true
	fi
fi

_ui_ok "Console TTY configurado com sucesso (fonte ${_target_font} e cursor em bloco)!"
