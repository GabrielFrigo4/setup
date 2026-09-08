# 🌐 FreeBSD Common — Catálogo de Receitas Universais

> Receitas base compartilhadas entre todos os ambientes FreeBSD (Desktop KDE, Servidor KVM, Jails & Bastille).

---

## 🎯 Finalidade

Esta pasta centraliza as configurações essenciais do FreeBSD que independem de interface gráfica ou contexto de servidor: elevação de privilégios (`doas`), parâmetros de kernel e utilitários modernos de terminal.

---

## 📂 Catálogo de Receitas

| Recurso       | Receita                                                          | Descrição                                                                                       |
| :------------ | :--------------------------------------------------------------- | :---------------------------------------------------------------------------------------------- |
| **`system/`** | [`../../common/system/nopass.sh`](../../common/system/nopass.sh) | Configura `doas` e `sudo` sem senha para Desktop (0440)                                         |
| **`system/`** | [`system/sysctl.sh`](system/sysctl.sh)                           | Desativa core dumps e aplica parâmetros recomendados no `/etc/sysctl.conf`                      |
| **`tools/`**  | [`tools/cli.sh`](tools/cli.sh)                                   | Instala utilitários CLI modernos (`eza`, `bat`, `ripgrep`, `fd-find`, `git`, `gh`, `fastfetch`) |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita diretamente via terminal no FreeBSD:

```sh
# Configurar elevação de privilégios sem senha (doas + sudo)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/system/nopass.sh | sh


# Instalar utilitários CLI
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/freebsd/common/tools/cli.sh | sh
```
