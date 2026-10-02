# 🍥 Debian — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar estações de trabalho rodando Debian GNU/Linux.

---

## 🎯 Finalidade

Organiza a configuração do Debian em módulos atômicos: repositórios non-free, doas (`0440`), drivers proprietários Nvidia, editores e utilitários.

> ℹ️ **Containers & Infraestrutura Base:** Receitas de containers (Incus, Podman, Docker) residem em [`../../container/`](../../container/README.md) e infraestrutura base (Swap, doas, Flatpak, Wireshark, Antigravity) em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo de Receitas

| Categoria      | Receita                                    | Descrição                                           |
| :------------- | :----------------------------------------- | :-------------------------------------------------- |
| **`system/`**  | [`system/base.sh`](system/base.sh)         | Repositórios non-free, usuário e pacotes essenciais |
| **`desktop/`** | [`desktop/drivers.sh`](desktop/drivers.sh) | Mesa, Nvidia proprietary drivers e firmwares        |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Copie os comandos da receita desejada e execute no terminal do Debian:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/linux/desktop/debian/desktop/drivers.sh | sh
```
