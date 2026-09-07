# 🐧 Fedora Workstation — Catálogo de Receitas (Cookbook)

> Receitas atômicas, modulares e idempotentes para a estação de trabalho Fedora com GNOME Wayland puro.

---

## 🎯 Finalidade

Esta pasta concentra o provisionamento da estação de trabalho primária Linux (Fedora Workstation). Cada script atua como uma receita independente para configurar aspectos visuais do GNOME, aceleradores de hardware ou ferramentas de linha de comando.

> ℹ️ **Containers & Infraestrutura Base:** Receitas de containers (Incus, Podman, Docker) residem em [`../../container/`](../../container/README.md) e infraestrutura base (Swap, doas, Flatpak, Wireshark, Antigravity) em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo Categorizado de Receitas

| Categoria      | Receita                                | Descrição                                                                                               |
| :------------- | :------------------------------------- | :------------------------------------------------------------------------------------------------------ |
| **`system/`**  | [`system/base.sh`](system/base.sh)     | Sistema base: fuse-sshfs, mascaramento do fwupd e modelos de arquivos no GNOME (`~/Modelos`)            |
| **`desktop/`** | [`desktop/gnome.sh`](desktop/gnome.sh) | Tema Adwaita escuro, botões da janela (`:minimize,maximize,close`) e atalhos (`Super + T`, `Super + A`) |
| **`desktop/`** | [`desktop/fonts.sh`](desktop/fonts.sh) | Instalação e mapeamento métrico das fontes Carlito e Caladea em `fonts.conf`                            |
| **`tools/`**   | [`tools/cli.sh`](tools/cli.sh)         | Bibliotecas gráficas de terminal FTXUI e Notcurses                                                      |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita individualmente via terminal:

```sh
# Aplicar atalhos e tema escuro no GNOME
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/desktop/fedora/desktop/gnome.sh | sh

# Configurar sistema base
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/desktop/fedora/system/base.sh | sh
```
