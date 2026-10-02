# 🌐 FreeBSD Common — Catálogo de Receitas Universais

> Receitas base compartilhadas entre todos os ambientes FreeBSD (Desktop KDE, Servidor KVM, Jails & Bastille).

---

## 🎯 Finalidade

Esta pasta centraliza as configurações essenciais do FreeBSD que independem de interface gráfica ou contexto de servidor: elevação de privilégios (`doas`), parâmetros de kernel e utilitários modernos de terminal.

---

## 📂 Catálogo de Receitas

| Recurso       | Receita                                                                | Descrição                                                                                    |
| :------------ | :--------------------------------------------------------------------- | :------------------------------------------------------------------------------------------- |
| **`system/`** | [`../../common/system/nopass.sh`](../../common/system/nopass.sh)       | Configura `doas` e `sudo` sem senha para Desktop (0440)                                      |
| **`system/`** | [`system/sysctl.sh`](system/sysctl.sh)                                 | Desativa core dumps, define áudio USB padrão e parâmetros no `/etc/sysctl.conf`              |
| **`common/`** | [`../../common/cli/core.sh`](../../common/cli/core.sh)                 | Instala utilitários CLI modernos (`eza`, `bat`, `ripgrep`, `fd-find`, `zoxide`, `fastfetch`) |
| **`common/`** | [`../../common/graphics/shaders.sh`](../../common/graphics/shaders.sh) | Toolchains de shaders (Vulkan, Slang, DXC, glslang, shaderc, SPIRV-Cross)                    |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita diretamente via terminal no FreeBSD:

```sh
# Configurar elevação de privilégios sem senha (doas + sudo)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/nopass.sh | sh

# Ajustar parâmetros de kernel e áudio no sysctl.conf
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/freebsd/common/system/sysctl.sh | sh

# Instalar utilitários CLI universais
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/cli/core.sh | sh
```
