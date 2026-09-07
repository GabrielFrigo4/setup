# 🔤 Common System & Nerd Fonts

> Receita universal em POSIX Shell para download e instalação de fontes tipográficas e Nerd Fonts no Host.

---

## 🎯 Finalidade

Esta pasta fornece o script para instalar as fontes de programação essenciais para a interface gráfica e emuladores de terminal (**JetBrains Mono Nerd Font**, **Roboto Mono Nerd Font** e **MesloLGS NF**).

> ℹ️ **Automações Windows (PowerShell):** A receita equivalente para Windows reside em [`../../windows/native/fonts/fonts.ps1`](../../windows/native/fonts/fonts.ps1).

---

## 📂 Catálogo de Arquivos

| Arquivo                | Plataforma                    | Descrição                                                                                  |
| :--------------------- | :---------------------------- | :----------------------------------------------------------------------------------------- |
| [`fonts.sh`](fonts.sh) | Linux / FreeBSD / macOS / WSL | Baixa Nerd Fonts em `~/.local/share/fonts` e atualiza o cache do `fontconfig` (`fc-cache`) |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute diretamente no terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/fonts/fonts.sh | sh
```
