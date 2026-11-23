# 🍎 O Ecossistema macOS (Darwin & POSIX)

> Compatibilidade multiplataforma, conformidade POSIX e consumo de receitas universais no macOS.

---

## 🎯 Visão Geral

O **macOS** (kernel Darwin / subsistema BSD) é suportado no repositório **Setup** através da camada multiplataforma agnóstica (**`common/`**) e do repositório **Profile**.

Graças à adesão rigorosa aos padrões POSIX e ao shebang universal `#!/usr/bin/env sh`, as receitas universais com suporte a `brew` e utilitários POSIX operam de forma transparente no macOS.

---

## 📂 Recursos Multiplataforma Compatíveis

### 1. 🌐 Receitas Universais ([`common/`](../common/README.md))

- **Editores:** [`common/editors/install.sh`](../common/editors/install.sh) instala editores modais e Emacs.
- **Utilitários & VCS:** [`common/cli/core.sh`](../common/cli/core.sh) e [`common/vcs/tools.sh`](../common/vcs/tools.sh) provêm ferramentas modernas de CLI e Git/GitHub CLI.
- **Fontes do Sistema:** [`common/fonts/fonts.sh`](../common/fonts/fonts.sh) instala fontes tipográficas em `~/Library/Fonts/`.
- **Formatadores & Linters:** [`common/linters/prettier.sh`](../common/linters/prettier.sh), [`common/linters/ruff.sh`](../common/linters/ruff.sh) e [`common/linters/mermaid.sh`](../common/linters/mermaid.sh) instalam os formatadores CLI.

---

## ⚙️ 2. Dotfiles Declarativos ([Profile](https://github.com/GabrielFrigo4/profile))

Os arquivos declarativos no repositório **Profile** operam no macOS no espaço do usuário:

- **Editores GUI:** Configurações de VS Code, Antigravity e Zed (`~/Library/Application Support/Code/User/settings.json` ou `~/.config/`).
- **Formatadores Globais:** `.clang-format`, `.prettierrc`, `.stylua.toml` posicionados em `$HOME`.
- **Terminais:** Perfis de Nushell e configurações de Zsh integradas ao repositório **Shell**.

---

## 🚀 Como Usar no macOS (Clone Soberano)

Bootstrap completo em 1 linha ou execução pontual a partir do clone em `~/.local/share/setup`:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/bootstrap.sh | sh -s -- --profile=base

sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/linters/prettier.sh"
```
