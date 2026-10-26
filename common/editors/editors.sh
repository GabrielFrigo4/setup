#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common Editors Configuration
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando perfis de editores de código..."

### --------------------------------
### Emacs Configuration
### --------------------------------
if [ ! -d "${HOME}/.emacs.d/.git" ]; then
	mkdir -p "${HOME}/.emacs.d"
	git clone "https://github.com/GabrielFrigo4/emacs.git" "${HOME}/.emacs.d"
else
	git -C "${HOME}/.emacs.d" pull || true
fi

_apps_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/applications"
mkdir -p "${_apps_dir}"
cat << 'EOF' > "${_apps_dir}/emacs.desktop"
[Desktop Entry]
Name=Emacs
GenericName=Text Editor
Comment=Edit text (GNU Emacs Client & Server)
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;x-scheme-handler/org-protocol;
Exec=emacsclient --create-frame --alternate-editor="" %F
Icon=emacs
Type=Application
Terminal=false
Categories=Development;TextEditor;
StartupNotify=false
StartupWMClass=Emacs
Keywords=emacs;emacsclient;editor;daemon;server;
Actions=new-frame;new-instance;

[Desktop Action new-frame]
Name=New Frame
Exec=emacsclient --create-frame --alternate-editor="" %F

[Desktop Action new-instance]
Name=New Standalone Instance
Exec=emacs %F
EOF
chmod 0644 "${_apps_dir}/emacs.desktop"
if command -v update-desktop-database > "/dev/null" 2>&1; then
	update-desktop-database "${_apps_dir}" 2> "/dev/null" || true
fi

if [ -n "${ELEVATE:-}" ] || [ "$(id -u)" -eq 0 ]; then
	if [ -w "/usr/local/share/applications" ] || [ "$(id -u)" -eq 0 ]; then
		mkdir -p "/usr/local/share/applications" 2> "/dev/null" || true
		cp -f "${_apps_dir}/emacs.desktop" "/usr/local/share/applications/emacs.desktop" 2> "/dev/null" || true
		chmod 0644 "/usr/local/share/applications/emacs.desktop" 2> "/dev/null" || true
		command -v update-desktop-database > "/dev/null" 2>&1 && update-desktop-database "/usr/local/share/applications" 2> "/dev/null" || true
	elif [ -n "${ELEVATE:-}" ]; then
		${ELEVATE} mkdir -p "/usr/local/share/applications" 2> "/dev/null" || true
		${ELEVATE} cp -f "${_apps_dir}/emacs.desktop" "/usr/local/share/applications/emacs.desktop" 2> "/dev/null" || true
		${ELEVATE} chmod 0644 "/usr/local/share/applications/emacs.desktop" 2> "/dev/null" || true
		command -v update-desktop-database > "/dev/null" 2>&1 && ${ELEVATE} update-desktop-database "/usr/local/share/applications" 2> "/dev/null" || true
	fi

	if [ -f "/usr/share/applications/emacs.desktop" ]; then
		if [ -w "/usr/share/applications/emacs.desktop" ]; then
			sed -i 's|^Exec=emacs %F|Exec=emacsclient --create-frame --alternate-editor="" %F|' "/usr/share/applications/emacs.desktop" 2> "/dev/null" || true
			command -v update-desktop-database > "/dev/null" 2>&1 && update-desktop-database "/usr/share/applications" 2> "/dev/null" || true
		elif [ -n "${ELEVATE:-}" ]; then
			${ELEVATE} sed -i 's|^Exec=emacs %F|Exec=emacsclient --create-frame --alternate-editor="" %F|' "/usr/share/applications/emacs.desktop" 2> "/dev/null" || true
			command -v update-desktop-database > "/dev/null" 2>&1 && ${ELEVATE} update-desktop-database "/usr/share/applications" 2> "/dev/null" || true
		fi
	fi
fi

### --------------------------------
### NeoVim Configuration
### --------------------------------
if [ ! -d "${HOME}/.config/nvim/.git" ]; then
	mkdir -p "${HOME}/.config/nvim"
	git clone "https://github.com/GabrielFrigo4/neovim.git" "${HOME}/.config/nvim"
else
	git -C "${HOME}/.config/nvim" pull || true
fi

### --------------------------------
### Vim Configuration
### --------------------------------
if [ ! -d "${HOME}/.vim/.git" ]; then
	git clone "https://github.com/GabrielFrigo4/vim.git" "${HOME}/.vim"
else
	git -C "${HOME}/.vim" pull || true
fi

cat << 'EOF' | tee "${HOME}/.vimrc" > "/dev/null"
set rtp+=~/.vim
source ~/.vim/vimrc
EOF

### --------------------------------
### Helix Configuration
### --------------------------------
if [ ! -d "${HOME}/.config/helix/.git" ]; then
	mkdir -p "${HOME}/.config/helix"
	git clone "https://github.com/GabrielFrigo4/helix.git" "${HOME}/.config/helix"
else
	git -C "${HOME}/.config/helix" pull || true
fi

### --------------------------------
### Micro Configuration
### --------------------------------
mkdir -p "${HOME}/.config/micro/colorschemes"
if [ ! -f "${HOME}/.config/micro/colorschemes/dracula.micro" ]; then
	_tmp_micro="$(mktemp -d)"
	git clone --depth 1 "https://github.com/dracula/micro.git" "${_tmp_micro}"
	cp "${_tmp_micro}/dracula.micro" "${HOME}/.config/micro/colorschemes/dracula.micro"
	rm -rf "${_tmp_micro}"
fi

cat << 'EOF' | tee "${HOME}/.config/micro/settings.json" > "/dev/null"
{
	"colorscheme": "dracula"
}
EOF

_ui_ok "Perfis de editores configurados com sucesso!"
