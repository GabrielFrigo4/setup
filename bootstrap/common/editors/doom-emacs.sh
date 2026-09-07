#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Doom Emacs Framework Complete Setup
# ------------------------------------------------------------------------------
set -eu

rm -rf "${HOME}/.emacs" "${HOME}/.emacs.d" "${HOME}/.config/emacs" "${HOME}/.config/doom" 2> "/dev/null" || true

git clone --depth 1 "https://github.com/doomemacs/doomemacs" "${HOME}/.config/emacs"
mkdir -p "${HOME}/.config/doom/snippets"
"${HOME}/.config/emacs/bin/doom" install --force

cat << 'EOF' | tee -a "${HOME}/.config/doom/packages.el" > "/dev/null"
(package! mermaid-mode)
(package! ob-mermaid)
EOF
"${HOME}/.config/emacs/bin/doom" sync

sed -i 's/;;tree-sitter/tree-sitter/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;(cc +lsp)/(cc +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;(rust +lsp)/(rust +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;python/(python +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;javascript/(javascript +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;typescript/(typescript +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;toml/(toml +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/;;sql/(sql +lsp +tree-sitter)/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
sed -i 's/sh[[:space:]]*;/(sh +tree-sitter) ;/' "${HOME}/.config/doom/init.el" 2> "/dev/null" || true
"${HOME}/.config/emacs/bin/doom" sync

cat << 'EOF' | tee -a "${HOME}/.config/doom/config.el" > "/dev/null"
(setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 16 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 16))
(blink-cursor-mode t)

(use-package! mermaid-mode
  :mode "\\.mermaid\\'"
  :mode "\\.mmd\\'"
  :config
  (setq mermaid-mmdc-location "mmdc")
  (setq mermaid-output-format "png"))

(use-package! ob-mermaid
  :after org
  :config
  (setq ob-mermaid-cli-path "mmdc"))
EOF

"${HOME}/.config/emacs/bin/doom" sync
"${HOME}/.config/emacs/bin/doom" upgrade
