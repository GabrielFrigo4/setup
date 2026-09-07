# 🪟🐧 Linux WSL2 — Catálogo de Receitas

> Receitas modulares para inicialização e provisionamento de distribuições Linux executando sob o subsistema Windows Subsystem for Linux (WSL2).

---

## 🎯 Finalidade

Esta pasta organiza a configuração de distribuições Linux no WSL2: ativação do `systemd`, criação de usuário sem privilégios com grupo `wheel`/`sudo`, elevação com `doas` (`0440`) e utilitários modernos de terminal.

---

## 📂 Catálogo de Receitas

| Distribuição       | Gerenciador | Receita                  | Descrição                                                                  |
| :----------------- | :---------- | :----------------------- | :------------------------------------------------------------------------- |
| **Fedora / Rocky** | `dnf`       | [`fedora.sh`](fedora.sh) | Setup completo do Fedora/Rocky no WSL: systemd, doas (0440) e dev tools    |
| **Arch Linux**     | `pacman`    | [`arch.sh`](arch.sh)     | Setup completo do Arch no WSL: systemd, keyring, doas (0440) e dev tools   |
| **Debian**         | `apt`       | [`debian.sh`](debian.sh) | Setup completo do Debian no WSL: systemd, sudoers, doas (0440) e dev tools |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Abra o terminal da sua distribuição no WSL2 e execute diretamente:

```sh
# Provisionar Fedora / Rocky Linux no WSL2 (DNF)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/wsl/fedora.sh | sh

# Provisionar Arch Linux no WSL2 (Pacman)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/wsl/arch.sh | sh

# Provisionar Debian no WSL2 (APT)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/wsl/debian.sh | sh
```
