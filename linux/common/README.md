# 🌐 Linux Common — Catálogo de Receitas Universais

> Receitas base compartilhadas entre todas as distribuições Linux (Fedora, Arch Linux, Debian, Ubuntu, Rocky Linux).

---

## 🎯 Finalidade

Esta pasta centraliza as receitas de infraestrutura de sistema, ferramentas e segurança que são **universais para qualquer distribuição Linux**, independentemente do ambiente (Desktop, Servidor VPS, WSL2 ou Container).

> ℹ️ **Containers de Sistema & Aplicação:** As receitas de Incus, Podman e Docker residem no pilar dedicado [`../container/`](../container/README.md).

---

## 📂 Catálogo de Receitas

| Categoria       | Receita                                                          | Descrição                                                              |
| :-------------- | :--------------------------------------------------------------- | :--------------------------------------------------------------------- |
| **`system/`**   | [`system/swap.sh`](system/swap.sh)                               | Alocação de 2GB de Swap e `vm.swappiness=10` (Agnóstico de SO)         |
| **`system/`**   | [`../../common/system/nopass.sh`](../../common/system/nopass.sh) | Elevação com `doas` e `sudo` sem senha para desktop/workstation (0440) |
| **`system/`**   | [`system/flatpak.sh`](system/flatpak.sh)                         | Instalação universal de Flatpak e integração com o repositório Flathub |
| **`security/`** | [`security/firewall.sh`](security/firewall.sh)                   | Regras de portas 22, 80 e 443 para `firewalld`, `ufw` e `iptables`     |
| **`security/`** | [`security/wireshark.sh`](security/wireshark.sh)                 | Instalação do Wireshark e adição do usuário ao grupo `wireshark`       |
| **`tools/`**    | [`tools/antigravity.sh`](tools/antigravity.sh)                   | Instalação do Antigravity IDE & CLI com lançador `.desktop` universal  |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita diretamente via terminal:

```sh
# Configurar Flatpak + Flathub
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/common/system/flatpak.sh | sh

# Configurar Antigravity IDE & CLI
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/common/tools/antigravity.sh | sh
```
