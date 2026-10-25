#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Linux Universal TTY Console Spleen Font
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"
. "${_setup_root}/core/detect.sh"

_target_font="${DETECTED_CONSOLE_FONT:-spleen-12x24}"
_spleen_version="2.2.0"

_ui_step "Configurando fonte Spleen (${_target_font}) para console TTY Linux..."

_font_found=0
for _cd in "/usr/lib/kbd/consolefonts" "/usr/share/kbd/consolefonts" "/usr/share/consolefonts"; do
	{ [ -f "${_cd}/${_target_font}.psfu" ] || [ -f "${_cd}/${_target_font}.psfu.gz" ] || [ -f "${_cd}/${_target_font}.psf.gz" ]; } && _font_found=1 && break
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
	[ -d "${_primary_dir}" ] || ${ELEVATE} mkdir -p "${_primary_dir}"

	${ELEVATE} cp "${_tmp_dir}/spleen-${_spleen_version}"/spleen-*.psfu "${_primary_dir}/"
	${ELEVATE} chmod 0644 "${_primary_dir}"/spleen-*.psfu

	for _extra_dir in "/usr/lib/kbd/consolefonts" "/usr/share/kbd/consolefonts" "/usr/share/consolefonts"; do
		[ -d "${_extra_dir}" ] && [ "${_extra_dir}" != "${_primary_dir}" ] && ${ELEVATE} cp "${_tmp_dir}/spleen-${_spleen_version}"/spleen-*.psfu "${_extra_dir}/" && ${ELEVATE} chmod 0644 "${_extra_dir}"/spleen-*.psfu
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
		${ELEVATE} sed -i 's|^[[:space:]]*FONTSIZE=.*|FONTSIZE="'"${_target_font#spleen-}"'"|' "/etc/default/console-setup"
	fi
	command -v setupcon > "/dev/null" 2>&1 && ${ELEVATE} setupcon --save 2> "/dev/null" || true
fi

### --------------------------------
### Escalonamento Dinâmico de Fonte
### --------------------------------
_autofont_bin="/usr/local/libexec/vconsole-autofont"
[ -d "/usr/local/libexec" ] || ${ELEVATE} mkdir -p "/usr/local/libexec"
${ELEVATE} cp "${_setup_root}/linux/common/system/vconsole-autofont.sh" "${_autofont_bin}"
${ELEVATE} chmod 0755 "${_autofont_bin}"
${ELEVATE} "${_autofont_bin}" --setup

### --------------------------------
### Configuração do Cursor em Bloco
### --------------------------------
_ui_sub "Configurando cursor em bloco padrão no console Linux (vt.cur_default=0xee10)..."

if [ -f "/etc/default/grub" ]; then
	if ! grep -q "vt\.cur_default=" "/etc/default/grub" 2> "/dev/null"; then
		grep -q "^[[:space:]]*GRUB_CMDLINE_LINUX=" "/etc/default/grub" 2> "/dev/null" \
			&& ${ELEVATE} sed -i 's|^[[:space:]]*GRUB_CMDLINE_LINUX="\(.*\)"|GRUB_CMDLINE_LINUX="\1 vt.cur_default=0xee10"|' "/etc/default/grub" \
			|| { grep -q "^[[:space:]]*GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" 2> "/dev/null" && ${ELEVATE} sed -i 's|^[[:space:]]*GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"|GRUB_CMDLINE_LINUX_DEFAULT="\1 vt.cur_default=0xee10"|' "/etc/default/grub"; }
	fi

	if grep -q '^[[:space:]]*GRUB_TERMINAL_OUTPUT="console"' "/etc/default/grub" 2> "/dev/null"; then
		${ELEVATE} sed -i 's|^[[:space:]]*GRUB_TERMINAL_OUTPUT="console"|GRUB_TERMINAL_OUTPUT="gfxterm"|' "/etc/default/grub"
	fi

	grep -q "^[[:space:]]*GRUB_GFXMODE=" "/etc/default/grub" 2> "/dev/null" \
		&& ${ELEVATE} sed -i 's|^[[:space:]]*GRUB_GFXMODE=.*|GRUB_GFXMODE="auto"|' "/etc/default/grub" \
		|| echo 'GRUB_GFXMODE="auto"' | ${ELEVATE} tee -a "/etc/default/grub" > "/dev/null"
	grep -q "^[[:space:]]*GRUB_GFXPAYLOAD_LINUX=" "/etc/default/grub" 2> "/dev/null" \
		|| echo 'GRUB_GFXPAYLOAD_LINUX="keep"' | ${ELEVATE} tee -a "/etc/default/grub" > "/dev/null"

	command -v grubby > "/dev/null" 2>&1 && ${ELEVATE} grubby --update-kernel=ALL --args="vt.cur_default=0xee10" 2> "/dev/null" || true

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
	w /sys/module/vt/parameters/default_red - - - - 0,127,0,196,51,127,0,191,115,255,0,255,115,255,0,255
	w /sys/module/vt/parameters/default_grn - - - - 0,0,127,161,102,0,127,191,130,0,255,255,158,0,255,255
	w /sys/module/vt/parameters/default_blu - - - - 0,0,0,0,163,127,127,191,138,0,0,0,207,255,255,255
	EOF
fi
[ -f "/sys/module/vt/parameters/cur_default" ] && echo 60944 | ${ELEVATE} tee /sys/module/vt/parameters/cur_default > "/dev/null" 2>&1 || true
[ -f "/sys/class/graphics/fbcon/cursor_blink" ] && echo 0 | ${ELEVATE} tee /sys/class/graphics/fbcon/cursor_blink > "/dev/null" 2>&1 || true
for _ch in red:0,127,0,196,51,127,0,191,115,255,0,255,115,255,0,255 grn:0,0,127,161,102,0,127,191,130,0,255,255,158,0,255,255 blu:0,0,0,0,163,127,127,191,138,0,0,0,207,255,255,255; do
	_param="/sys/module/vt/parameters/default_${_ch%%:*}"
	[ -f "${_param}" ] && echo "${_ch#*:}" | ${ELEVATE} tee "${_param}" > "/dev/null" 2>&1 || true
done

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
_vts="/dev/tty0 /dev/tty1 /dev/tty2 /dev/tty3 /dev/tty4 /dev/tty5 /dev/tty6"

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
		[ -c "${_c}" ] && [ "${_c}" != "/dev/tty0" ] && ${ELEVATE} setfont -C "${_c}" "${_target_font}" 2> "/dev/null" || true
	done
fi

if command -v loadkeys > "/dev/null" 2>&1 && [ -f "${_keymap_dir}/standard-fkeys.map" ]; then
	${ELEVATE} loadkeys -C /dev/tty0 "${_keymap_dir}/standard-fkeys.map" 2> "/dev/null" || true
	for _c in ${_unique_vts}; do
		[ -c "${_c}" ] && [ "${_c}" != "/dev/tty0" ] && ${ELEVATE} loadkeys -C "${_c}" "${_keymap_dir}/standard-fkeys.map" 2> "/dev/null" || true
	done
fi

if command -v systemctl > "/dev/null" 2>&1 && systemctl is-active --quiet systemd-vconsole-setup.service 2> "/dev/null"; then
	${ELEVATE} systemctl restart systemd-vconsole-setup.service 2> "/dev/null" || true
fi

### --------------------------------
### Mouse de Console GPM
### --------------------------------
if ! command -v gpm > "/dev/null" 2>&1; then
	command -v dnf > "/dev/null" 2>&1 && ${ELEVATE} dnf install --assumeyes gpm
	command -v apt-get > "/dev/null" 2>&1 && ${ELEVATE} apt-get install --yes gpm 2> "/dev/null" || true
	command -v pacman > "/dev/null" 2>&1 && ${ELEVATE} pacman -S --needed --noconfirm gpm
fi

if command -v gpm > "/dev/null" 2>&1; then
	[ -f "/etc/sysconfig/gpm" ] && ${ELEVATE} sed -i 's|^APPEND=.*|APPEND="-a 2 -r 100"|' "/etc/sysconfig/gpm" 2> "/dev/null" || true
	command -v systemctl > "/dev/null" 2>&1 && ${ELEVATE} systemctl enable --now gpm.service 2> "/dev/null" || true
fi

### --------------------------------
### Terminfo Sanitizado Console
### --------------------------------
if command -v tic > "/dev/null" 2>&1; then
	_ui_sub "Instalando terminfo de console com cursores sanitizados..."
	_tmp_ti="$(mktemp)"
	cat <<- "EOF" > "${_tmp_ti}"
	linux|linux console with sanitized non-destructive cursor,
		cnorm=\E[?25h,
		cvvis=\E[?25h,
		civis=\E[?25l,
		use=linux,
	EOF
	${ELEVATE} tic -o "/etc/terminfo" "${_tmp_ti}" 2> "/dev/null" || ${ELEVATE} tic -o "/usr/share/terminfo" "${_tmp_ti}" 2> "/dev/null" || tic -o "${HOME}/.terminfo" "${_tmp_ti}" 2> "/dev/null" || true
	rm -f "${_tmp_ti}"
fi

_ui_ok "Console TTY configurado com sucesso (fonte ${_target_font} e cursor em bloco)!"
