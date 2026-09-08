# 🌿 Version Control Systems (Git & Got)

> Receitas universais em POSIX Shell para configuração declarativa de controle de versão.

---

## 🎯 Finalidade

Esta pasta fornece scripts de configuração global em POSIX Shell para o **Git** (padrão universal) e para o **Game of Trees (Got)** (VCS nativo do ecossistema OpenBSD/FreeBSD).

Os scripts aplicam boas práticas recomendadas (branch padrão `main`, autocrlf adequado ao SO, merge sem rebase acidental) e consomem credenciais de autor (`GIT_AUTHOR_NAME` e `GIT_AUTHOR_EMAIL`) exportadas pelo **Vault** se estiverem disponíveis no ambiente.

> ℹ️ **Automações Windows (CMD):** As receitas equivalentes para Windows residem em [`../../windows/native/`](../../windows/native/README.md).

---

## 📂 Catálogo de Arquivos

| Arquivo            | Plataforma                            | Descrição                                                 |
| :----------------- | :------------------------------------ | :-------------------------------------------------------- |
| [`git.sh`](git.sh) | Linux / FreeBSD / macOS / WSL / MSYS2 | Configura Git globalmente com variáveis do ambiente/Vault |
| [`got.sh`](got.sh) | FreeBSD / OpenBSD / Linux             | Gera `~/.gotconfig` com dados do autor do Vault           |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute diretamente via terminal:

```sh
# Configurar Git no UNIX
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/vcs/git.sh | sh

# Configurar Got no UNIX
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/vcs/got.sh | sh
```
