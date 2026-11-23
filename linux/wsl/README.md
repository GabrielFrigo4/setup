# 🪟🐧 Linux WSL2 — Catálogo de Receitas

> Receitas modulares para inicialização e provisionamento de distribuições Linux executando sob o subsistema Windows Subsystem for Linux (WSL2).

---

## 🎯 Finalidade

Esta pasta organiza a configuração de distribuições Linux no WSL2: ativação do `systemd`, criação do usuário `${TARGET_USER:-$(id -un)}` com elevação `${ELEVATE}` no grupo `wheel`/`sudo`, `doas` (`0440`) e utilitários modernos de terminal.

---

## 📂 Catálogo de Receitas

| Distribuição       | Gerenciador | Receita                  | Descrição                                                                   |
| :----------------- | :---------- | :----------------------- | :-------------------------------------------------------------------------- |
| **Fedora / Rocky** | `dnf`       | [`fedora.sh`](fedora.sh) | Setup completo do Fedora/Rocky no WSL: systemd, doas (`0440`) e dev tools   |
| **Arch Linux**     | `pacman`    | [`arch.sh`](arch.sh)     | Setup completo do Arch no WSL: systemd, keyring, doas (`0440`) e dev tools  |
| **Debian**         | `apt`       | [`debian.sh`](debian.sh) | Setup completo do Debian no WSL: systemd, sudoers, doas (`0440`), dev tools |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/wsl/fedora.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/wsl/arch.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/wsl/debian.sh"
```
