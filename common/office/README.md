# 📄 Office Suites — Catálogo de Produtividade Multiplataforma

> Receitas modulares e idempotentes para provisionamento de suites de produtividade e documentos de escritório em Linux, FreeBSD e Windows.

---

## 🎯 Finalidade

Esta pasta centraliza as rotinas de instalação e configuração de suites de escritório modernas, com foco prioritário no **Collabora Office Desktop** — a implementação desktop aberta construída sobre o motor do Collabora Online / LibreOffice, com interface limpa e foco em privacidade e compatibilidade ODF/OOXML.

---

## 📂 Catálogo de Recursos

| Recurso                            | Tipo    | Plataformas Alvo      | Método de Provisionamento                                                     |
| :--------------------------------- | :------ | :-------------------- | :---------------------------------------------------------------------------- |
| **[`collabora.sh`](collabora.sh)** | Receita | Linux, FreeBSD, MSYS2 | Dispatch universal (`pkg` / `dnf` / `apt` / `pacman` / Flatpak Flathub / AUR) |

---

## 🌐 Suporte por Plataforma

### 🐧 Linux

- **Flathub (Universal):** Aplicação empacotada oficialmente sob o ID `com.collaboraoffice.Office`.
- **Arch Linux (AUR):** Binário mantido pela comunidade através do pacote `collabora-office-bin`.

### 🪟 Windows

- **Microsoft Store / Winget:** Distribuído oficialmente via Microsoft Store com o Product ID `9P9MRBXJJG0M` (`Collabora Office Desktop`).
- **Comando Equivalente:**
    ```cmd
    winget install 9P9MRBXJJG0M --accept-package-agreements --accept-source-agreements
    ```

### 😈 FreeBSD

- **Status Upstream:** Port oficial e suporte nativo em andamento pela comunidade e engenharia Collabora.
- **Auto-cura e Resiliência:** O script verifica proativamente a disponibilidade de `collabora-office` no repositório `pkg`. Assim que o port for publicado no catálogo oficial, o provisionamento ocorrerá sem necessidade de refatoração.

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute diretamente no terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/office/collabora.sh | sh
```
