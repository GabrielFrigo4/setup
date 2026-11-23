# 📟 Common Modern CLI Utilities

> Receitas universais em POSIX Shell para instalação de utilitários essenciais de terminal.

---

## 🎯 Finalidade

Esta pasta centraliza a instalação de ferramentas modernas de linha de comando: **bat**, **eza**, **fd**, **ripgrep**, **zoxide**, **fastfetch**, **tmux** e **zellij**.

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita                    | Descrição                                                           | Plataforma                                  |
| :----------------------------------- | :------------------------------------------------------------------ | :------------------------------------------ |
| [`core.sh`](core.sh)                 | Utilitários modernos de terminal (bat, eza, fd, ripgrep, fastfetch) | Linux / FreeBSD / macOS / WSL / MSYS2 / Win |
| [`bookokrat.sh`](bookokrat.sh)       | Leitor TUI de livros EPUB, PDF e DjVu (`bookokrat`)                 | Linux / FreeBSD / Cargo                     |
| [`multiplexers.sh`](multiplexers.sh) | Suite unificada de multiplexadores de terminal (Tmux & Zellij)      | Linux / FreeBSD / macOS / WSL / MSYS2 / Win |
| [`tmux.sh`](tmux.sh)                 | Multiplexador clássico e resiliente tmux                            | Linux / FreeBSD / macOS / WSL / MSYS2 / Win |
| [`zellij.sh`](zellij.sh)             | Multiplexador moderno e orientado a layouts Zellij em Rust          | Linux / FreeBSD / macOS / WSL / Win         |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/cli/core.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/cli/multiplexers.sh"
```
