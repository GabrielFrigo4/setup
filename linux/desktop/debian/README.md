# 🍥 Debian — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar estações de trabalho rodando Debian GNU/Linux.

---

## 🎯 Finalidade

Organiza a configuração do Debian em módulos atômicos: repositórios non-free, configuração base, guest Bhyve e drivers de aceleração.

> ℹ️ **Containers & Infraestrutura Base:** Receitas de containers (Incus, Podman, Docker) residem em [`../../container/`](../../container/README.md) e infraestrutura base (Swap, doas, Flatpak, Wireshark, Antigravity) em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo de Receitas

| Categoria      | Receita                                    | Descrição                                           |
| :------------- | :----------------------------------------- | :-------------------------------------------------- |
| **`system/`**  | [`system/base.sh`](system/base.sh)         | Repositórios non-free, usuário e pacotes essenciais |
| **`desktop/`** | [`desktop/drivers.sh`](desktop/drivers.sh) | Mesa, drivers Nvidia e firmwares                    |
| **`guest`**    | [`bhyve-guest.sh`](bhyve-guest.sh)         | Provisionamento de convidado Debian sob Bhyve       |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/setup.sh" --profile=debian-desktop
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/desktop/debian/desktop/drivers.sh"
```
