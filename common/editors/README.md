# 📝 Common Code Editors Setup

> Receitas modulares em POSIX Shell para instalação de editores de código e compilação do módulo nativo EWM.

---

## 🎯 Finalidade

Esta pasta reúne scripts autônomos em POSIX Shell para instalar binários de editores no sistema hospedeiro e compilar o módulo Wayland do **Emacs Wayland Manager (`ewm`)**. Configurações e dotfiles de editores são gerenciados pelos repositórios dedicados da **Suíte de Editores** (`Emacs`, `Helix`, `NeoVim`, `Vim`).

---

## 📂 Catálogo de Receitas

| Recurso             | Receita                    | Descrição                                                             |
| :------------------ | :------------------------- | :-------------------------------------------------------------------- |
| **Editor Packages** | [`install.sh`](install.sh) | Instalação de binários de editores (Neovim, Emacs, Vim, Helix, Micro) |
| **EWM (Wayland)**   | [`ewm.sh`](ewm.sh)         | Clona, compila via Cargo e instala o módulo nativo `libewm_core.so`   |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/editors/install.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/editors/ewm.sh"
```
