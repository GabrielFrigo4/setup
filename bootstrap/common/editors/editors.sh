#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Common Editors Configuration
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Common Editors]: Configurando perfis de editores de código..."

if [ ! -d "${HOME}/.emacs.d/.git" ]; then
	mkdir -p "${HOME}/.emacs.d"
	git clone "https://github.com/GabrielFrigo4/.emacs.d.git" "${HOME}/.emacs.d"
else
	git -C "${HOME}/.emacs.d" pull || true
fi

if [ ! -d "${HOME}/.config/nvim/.git" ]; then
	mkdir -p "${HOME}/.config/nvim"
	git clone "https://github.com/GabrielFrigo4/nvim.git" "${HOME}/.config/nvim"
else
	git -C "${HOME}/.config/nvim" pull || true
fi

if [ ! -d "${HOME}/vimfiles/.git" ]; then
	git clone "https://github.com/GabrielFrigo4/vimfiles.git" "${HOME}/vimfiles"
else
	git -C "${HOME}/vimfiles" pull || true
fi

cat << 'EOF' | tee "${HOME}/.vimrc" > "/dev/null"
set rtp+=~/vimfiles
source ~/vimfiles/vimrc
EOF

if [ ! -d "${HOME}/.config/helix/.git" ]; then
	mkdir -p "${HOME}/.config/helix"
	git clone "https://github.com/GabrielFrigo4/helix.git" "${HOME}/.config/helix"
else
	git -C "${HOME}/.config/helix" pull || true
fi

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

echo "✅ [Common Editors]: Perfis configurados com sucesso!"
