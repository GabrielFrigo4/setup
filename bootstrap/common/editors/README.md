# 📝 Common Code Editors & Frameworks Setup

> Receitas modulares em POSIX Shell para clonagem de perfis pessoais, frameworks de editores e sincronização de extensões de IDEs.

---

## 🎯 Finalidade

Esta pasta reúne scripts autônomos em POSIX Shell para provisionar editores de texto e código em ambientes UNIX (Linux, FreeBSD, macOS, WSL2 e MSYS2).

> ℹ️ **Automações Windows (.cmd / .ps1):** As receitas equivalentes para Windows residem em [`../../windows/native/`](../../windows/native/README.md).

---

## 📂 Catálogo de Receitas

| Editor / Ferramenta    | Receita                                    | Descrição                                                                                   |
| :--------------------- | :----------------------------------------- | :------------------------------------------------------------------------------------------ |
| **All Custom Editors** | [`editors.sh`](editors.sh)                 | Clona e atualiza todos os perfis pessoais de editores (Neovim, Emacs, Vim, Helix, Micro)    |
| **IDE Extensions**     | [`sync-extensions.sh`](sync-extensions.sh) | Sincroniza em lote a lista declarativa `extensions.txt` no VS Code, Antigravity ou VSCodium |
| **Doom Emacs**         | [`doom-emacs.sh`](doom-emacs.sh)           | Instala o Doom Emacs completo com módulos Treesitter e Mermaid                              |
| **LazyVim**            | [`lazyvim.sh`](lazyvim.sh)                 | Instala o starter completo do LazyVim com opções de cursor                                  |
| **SpaceVim**           | [`spacevim.sh`](spacevim.sh)               | Instala o SpaceVim com camadas de LSP, Git, Autocomplete e Shell                            |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

### 1. Clonar Todos os Perfis Pessoais de Editores:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/editors/editors.sh | sh
```

### 2. Sincronizar Extensões no VS Code / Antigravity / VSCodium:

```sh
# Instala todas as extensões declaradas
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/editors/sync-extensions.sh | sh

# Exporta extensões atuais para o arquivo
sh sync-extensions.sh export
```

### 3. Instalar Frameworks:

```sh
# Instalar LazyVim
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/editors/lazyvim.sh | sh

# Instalar Doom Emacs
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/editors/doom-emacs.sh | sh
```
