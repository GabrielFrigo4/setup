# 🐧 Fedora Workstation — Catálogo de Receitas

> Receitas atômicas, modulares e idempotentes para a estação de trabalho Fedora com GNOME Wayland puro.

---

## 🎯 Finalidade

Esta pasta concentra o provisionamento da estação de trabalho primária Linux (Fedora Workstation). Cada script atua como uma receita independente para configurar aspectos visuais do GNOME, sistema base e console TTY.

> ℹ️ **Containers & Infraestrutura Base:** Receitas de containers (Incus, Podman, Docker) residem em [`../../container/`](../../container/README.md) e infraestrutura base (Swap, doas, Flatpak, Wireshark, Antigravity) em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo Categorizado de Receitas

| Categoria      | Receita                                | Descrição                                                                                            |
| :------------- | :------------------------------------- | :--------------------------------------------------------------------------------------------------- |
| **`system/`**  | [`system/base.sh`](system/base.sh)     | Sistema base: `fuse-sshfs`, `zsh`, mascaramento do `fwupd` e templates em `xdg-user-dir TEMPLATES`   |
| **`desktop/`** | [`desktop/gnome.sh`](desktop/gnome.sh) | Tema adaptativo `adw-gtk3`/`adw-gtk3-dark` sincronizado a `color-scheme`, botões de janela e atalhos |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/setup.sh" --profile=fedora-desktop
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/desktop/fedora/desktop/gnome.sh"
```
