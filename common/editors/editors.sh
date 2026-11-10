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
### VTERM COMPILATION TOOLCHAIN
### --------------------------------
if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install -y devel/libtool devel/cmake 2> "/dev/null" || true
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes libtool cmake 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes libtool libtool-bin cmake 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-libtool \
			mingw-w64-ucrt-x86_64-cmake 2> "/dev/null" || true
	else
		${ELEVATE} pacman -S --needed --noconfirm libtool cmake 2> "/dev/null" || true
	fi
fi

### --------------------------------
### EMACS CONFIGURATION
### --------------------------------
_target="${HOME}/.emacs.d"
if [ -d "${_target}" ] && [ ! -d "${_target}/.git" ]; then
	rm -rf "${_target}"
fi
if [ ! -d "${_target}/.git" ]; then
	mkdir -p "${_target}"
	git clone "https://github.com/GabrielFrigo4/emacs.git" "${_target}"
else
	git -C "${_target}" pull || true
fi

_apps_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/applications"
mkdir -p "${_apps_dir}"
rm -f "${_apps_dir}/emacs.desktop"
cat << 'EOF' > "${_apps_dir}/emacs.desktop"
[Desktop Entry]
Name=Emacs
GenericName=Text Editor
Comment=Edit text (GNU Emacs Client & Server)
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;x-scheme-handler/org-protocol;
Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacsclient --create-frame --alternate-editor="" %F
Icon=emacs
Type=Application
Terminal=false
Categories=Development;TextEditor;
StartupNotify=false
StartupWMClass=Emacs
Keywords=emacs;emacsclient;editor;daemon;server;
NoDisplay=false
Actions=new-frame;new-instance;

[Desktop Action new-frame]
Name=New Frame
Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacsclient --create-frame --alternate-editor="" %F

[Desktop Action new-instance]
Name=New Standalone Instance
Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacs %F
EOF

for _hidden_app in "emacsclient.desktop" "emacs-mail.desktop" "emacsclient-mail.desktop"; do
	cat <<- EOF > "${_apps_dir}/${_hidden_app}"
	[Desktop Entry]
	Type=Application
	Name=Emacs
	NoDisplay=true
	EOF
done

chmod 0644 "${_apps_dir}"/emacs*.desktop
if command -v update-desktop-database > "/dev/null" 2>&1; then
	update-desktop-database "${_apps_dir}" 2> "/dev/null" || true
fi

if [ -n "${ELEVATE:-}" ] || [ "$(id -u)" -eq 0 ]; then
	if [ -w "/usr/local/share/applications" ] || [ "$(id -u)" -eq 0 ]; then
		mkdir -p "/usr/local/share/applications" 2> "/dev/null" || true
		cp -f "${_apps_dir}/emacs.desktop" "/usr/local/share/applications/emacs.desktop" 2> "/dev/null" || true
		for _hidden_app in "emacsclient.desktop" "emacs-mail.desktop" "emacsclient-mail.desktop"; do
			cp -f "${_apps_dir}/${_hidden_app}" "/usr/local/share/applications/${_hidden_app}" 2> "/dev/null" || true
		done
		chmod 0644 /usr/local/share/applications/emacs*.desktop 2> "/dev/null" || true
		command -v update-desktop-database > "/dev/null" 2>&1 && update-desktop-database "/usr/local/share/applications" 2> "/dev/null" || true
	elif [ -n "${ELEVATE:-}" ]; then
		${ELEVATE} mkdir -p "/usr/local/share/applications" 2> "/dev/null" || true
		${ELEVATE} cp -f "${_apps_dir}/emacs.desktop" "/usr/local/share/applications/emacs.desktop" 2> "/dev/null" || true
		for _hidden_app in "emacsclient.desktop" "emacs-mail.desktop" "emacsclient-mail.desktop"; do
			${ELEVATE} cp -f "${_apps_dir}/${_hidden_app}" "/usr/local/share/applications/${_hidden_app}" 2> "/dev/null" || true
		done
		${ELEVATE} chmod 0644 /usr/local/share/applications/emacs*.desktop 2> "/dev/null" || true
		command -v update-desktop-database > "/dev/null" 2>&1 && ${ELEVATE} update-desktop-database "/usr/local/share/applications" 2> "/dev/null" || true
	fi

	if [ -f "/usr/share/applications/emacs.desktop" ]; then
		if [ -w "/usr/share/applications/emacs.desktop" ]; then
			sed -i '' 's|^Exec=.*emacs.*|Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacsclient --create-frame --alternate-editor="" %F|' "/usr/share/applications/emacs.desktop" 2> "/dev/null" || \
				sed -i 's|^Exec=.*emacs.*|Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacsclient --create-frame --alternate-editor="" %F|' "/usr/share/applications/emacs.desktop" 2> "/dev/null" || true
			command -v update-desktop-database > "/dev/null" 2>&1 && update-desktop-database "/usr/share/applications" 2> "/dev/null" || true
		elif [ -n "${ELEVATE:-}" ]; then
			${ELEVATE} sed -i '' 's|^Exec=.*emacs.*|Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacsclient --create-frame --alternate-editor="" %F|' "/usr/share/applications/emacs.desktop" 2> "/dev/null" || \
				${ELEVATE} sed -i 's|^Exec=.*emacs.*|Exec=env GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 emacsclient --create-frame --alternate-editor="" %F|' "/usr/share/applications/emacs.desktop" 2> "/dev/null" || true
			command -v update-desktop-database > "/dev/null" 2>&1 && ${ELEVATE} update-desktop-database "/usr/share/applications" 2> "/dev/null" || true
		fi
	fi
fi

### --------------------------------
### NEOVIM CONFIGURATION
### --------------------------------
_target="${HOME}/.config/nvim"
if [ -d "${_target}" ] && [ ! -d "${_target}/.git" ]; then
	rm -rf "${_target}"
fi
if [ ! -d "${_target}/.git" ]; then
	mkdir -p "${_target}"
	git clone "https://github.com/GabrielFrigo4/neovim.git" "${_target}"
else
	git -C "${_target}" pull || true
fi

### --------------------------------
### VIM CONFIGURATION
### --------------------------------
_target="${HOME}/.vim"
if [ -d "${_target}" ] && [ ! -d "${_target}/.git" ]; then
	rm -rf "${_target}"
fi
if [ ! -d "${_target}/.git" ]; then
	git clone "https://github.com/GabrielFrigo4/vim.git" "${_target}"
else
	git -C "${_target}" pull || true
fi

cat << 'EOF' | tee "${HOME}/.vimrc" > "/dev/null"
set rtp+=~/.vim
source ~/.vim/vimrc
EOF

### --------------------------------
### HELIX CONFIGURATION
### --------------------------------
_target="${HOME}/.config/helix"
if [ -d "${_target}" ] && [ ! -d "${_target}/.git" ]; then
	rm -rf "${_target}"
fi
if [ ! -d "${_target}/.git" ]; then
	mkdir -p "${_target}"
	git clone "https://github.com/GabrielFrigo4/helix.git" "${_target}"
else
	git -C "${_target}" pull || true
fi

### --------------------------------
### MICRO CONFIGURATION
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
