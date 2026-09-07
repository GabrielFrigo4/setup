# 🍎 O Ecossistema macOS (Darwin & POSIX)

> Compatibilidade multiplataforma, conformidade POSIX e consumo de dotfiles declarativos no macOS.

---

## 🎯 Visão Geral

O **macOS** (baseado no kernel Darwin / subsistema BSD) é suportado no repositório **Configuration** através da camada multiplataforma agnóstica (**`bootstrap/common/`** e **`software/`**).

Graças à adesão rigorosa aos padrões POSIX e ao shebang universal `#!/usr/bin/env sh`, todas as ferramentas universais de desenvolvimento, formatadores de código e configurações declarativas funcionam de forma transparente no macOS.

---

## 📂 Recursos Multiplataforma Compatíveis

### 1. 🌐 Receitas Universais ([`bootstrap/common/`](../bootstrap/common/README.md))

- **Editores e Frameworks:** [`bootstrap/common/editors/editors.sh`](../bootstrap/common/editors/editors.sh) (clonagem de perfis pessoais), [`doom-emacs.sh`](../bootstrap/common/editors/doom-emacs.sh), [`lazyvim.sh`](../bootstrap/common/editors/lazyvim.sh) e [`spacevim.sh`](../bootstrap/common/editors/spacevim.sh).
- **Sincronização de Extensões:** [`bootstrap/common/editors/sync-extensions.sh`](../bootstrap/common/editors/sync-extensions.sh) instala e exporta plugins para VS Code, Antigravity e VSCodium no macOS.
- **Fontes do Sistema:** [`bootstrap/common/fonts/fonts.sh`](../bootstrap/common/fonts/fonts.sh) instala fontes tipográficas no diretório de fontes do usuário (`~/Library/Fonts/` ou `~/.local/share/fonts/`).
- **Formatadores e Linters:** [`bootstrap/common/linters/linters.sh`](../bootstrap/common/linters/linters.sh) implanta `.clang-format`, `.prettierrc`, `.stylua.toml` e `config.yaml` do Clangd.

---

## ⚙️ 2. Dotfiles Declarativos ([Profile](https://github.com/GabrielFrigo4/Profile))

Os arquivos estáticos puros no repositório **Profile** operam no macOS no espaço do usuário:

- **Editores GUI:** Configurações de VS Code, Antigravity e Zed (`~/Library/Application Support/Code/User/settings.json` ou `~/.config/`).
- **Formatadores Globais:** `.clang-format`, `.prettierrc`, `.stylua.toml` posicionados em `$HOME`.
- **Terminais:** Perfis de Nushell e configurações de Zsh integradas ao ecossistema do repositório **Shell**.

---

## 🚀 Como Usar no macOS (Zero-Clone)

Execute qualquer receita diretamente via terminal no macOS:

```sh
# Sincronizar extensões do VS Code / Antigravity
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/editors/sync-extensions.sh | sh

# Configurar formatadores globais (.clang-format, prettier, stylua)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/linters/linters.sh | sh
```
