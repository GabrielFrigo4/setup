# 🌐 Bootstrap Common (Multiplataforma POSIX) — Catálogo de Receitas

> Receitas modulares e universais em POSIX Shell (`.sh`) compartilhadas entre Linux, FreeBSD, macOS, WSL2 e MSYS2.

---

## 🎯 Finalidade

Esta pasta abriga receitas de automação que são **100% puras em POSIX Shell (`.sh`)**, agnósticas de distribuição e prontas para execução imediata em qualquer ambiente UNIX.

> ℹ️ **Automações Windows (.cmd / .ps1):** As receitas equivalentes para Windows residem em [`../windows/native/`](../windows/native/README.md).

---

## 📂 Catálogo de Recursos

| Recurso                                      | Tipo        | Descrição                                                                                      |
| :------------------------------------------- | :---------- | :--------------------------------------------------------------------------------------------- |
| **[`cli/`](cli/README.md)**                  | Receita     | Utilitários modernos de terminal (`core.sh`: bat, eza, fd, ripgrep, zoxide, fastfetch)         |
| **[`vcs/`](vcs/README.md)**                  | Receitas    | Instalação (`tools.sh`) e configuração global do Git (`git.sh`) e Game of Trees (`got.sh`)     |
| **[`editors/`](editors/README.md)**          | Subcatálogo | Instalação (`install.sh`), perfis pessoais (`editors.sh`) e frameworks (`lazyvim.sh`, etc.)    |
| **[`graphics/`](graphics/README.md)**        | Receitas    | Janelas / Multimídia (`windowing.sh`: GLFW, SDL3) e Shaders (`shaders.sh`: Vulkan, Slang, DXC) |
| **[`wasm/`](wasm/README.md)**                | Receita     | Compilador WebAssembly (`emscripten.sh`: C/C++ para Wasm)                                      |
| **[`media/`](media/README.md)**              | Receita     | Processamento de mídia (`cli.sh`: FFmpeg, ImageMagick, yt-dlp)                                 |
| **[`docs/`](docs/README.md)**                | Receita     | Editoração técnica e tipografia (`typesetting.sh`: Pandoc, TeX Live, PDFtk)                    |
| **[`security/`](security/README.md)**        | Receita     | Engenharia reversa e depuração (`re.sh`: LLDB, Valgrind, Strace, Radare2)                      |
| **[`fonts/`](fonts/README.md)**              | Receita     | Instalação de fontes tipográficas essenciais (`JetBrainsMono`, `RobotoMono`, `MesloLGS NF`)    |
| **[`linters/`](linters/README.md)**          | Receitas    | Implantação de formatadores (`linters.sh`), Prettier (`prettier.sh`) e Mermaid (`mermaid.sh`)  |
| **[`office/`](office/README.md)**            | Receita     | Suíte de escritório Collabora Office Desktop (`collabora.sh`) com dispatch universal           |
| **[`system/nopass.sh`](system/nopass.sh)**   | Receita     | Elevação de privilégios (`doas` + `sudo`) **sem senha** (0440)                                 |
| **[`system/persist.sh`](system/persist.sh)** | Receita     | Elevação de privilégios (`doas` + `sudo`) **com senha e sessão de 5 minutos** (0440)           |
| **[`system/strict.sh`](system/strict.sh)**   | Receita     | Elevação de privilégios (`doas` + `sudo`) **estrita (senha sempre / zero cache)** (0440)       |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita diretamente via terminal:

```sh
# Configurar privilégios sem senha (Desktop)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/nopass.sh | sh

# Configurar privilégios com sessão salva (Servidor / VPS)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/persist.sh | sh

# Configurar privilégios com senha sempre (Servidor Crítico / Estrito)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/strict.sh | sh

# Instalar fontes universais
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/fonts/fonts.sh | sh

# Configurar formatadores e linters globais
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/linters.sh | sh

# Instalar toolchains e bibliotecas gamedev (SDL3, GLFW, Emscripten)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/gamedev.sh | sh

# Configurar Git
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/vcs/git.sh | sh
```
