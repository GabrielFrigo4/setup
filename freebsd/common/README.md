# 🌐 FreeBSD Common — Catálogo de Receitas Universais

> Receitas base compartilhadas entre todos os ambientes FreeBSD (Desktop KDE, Servidor KVM, Jails & Bastille).

---

## 🎯 Finalidade

Esta pasta centraliza as configurações essenciais do FreeBSD que independem de interface gráfica ou hardware específico: elevação de privilégios (`doas`), parâmetros portáteis de kernel e utilitários modernos de terminal.

---

## 📂 Catálogo de Receitas

| Recurso       | Receita                                                                | Descrição                                                                                    |
| :------------ | :--------------------------------------------------------------------- | :------------------------------------------------------------------------------------------- |
| **`system/`** | [`../../common/system/nopass.sh`](../../common/system/nopass.sh)       | Configura `doas` e `sudo` sem senha para Desktop (`0440`)                                    |
| **`system/`** | [`system/sysctl.sh`](system/sysctl.sh)                                 | Desativa core dumps, ajusta limites de arquivos e memória IPC SHM no `/etc/sysctl.conf`      |
| **`common/`** | [`../../common/cli/core.sh`](../../common/cli/core.sh)                 | Instala utilitários CLI modernos (`eza`, `bat`, `ripgrep`, `fd-find`, `zoxide`, `fastfetch`) |
| **`common/`** | [`../../common/graphics/shaders.sh`](../../common/graphics/shaders.sh) | Toolchains de shaders (Vulkan, Slang, DXC, glslang, shaderc, SPIRV-Cross)                    |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/nopass.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/common/system/sysctl.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/cli/core.sh"
```
