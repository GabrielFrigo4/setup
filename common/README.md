# 🌐 Bootstrap Common (Multiplataforma POSIX) — Catálogo de Receitas

> Receitas modulares e universais em POSIX Shell (`.sh`) compartilhadas entre Linux, FreeBSD, macOS, WSL2 e MSYS2.

---

## 🎯 Finalidade

Esta pasta abriga receitas de automação que são **100% puras em POSIX Shell (`.sh`)**, agnósticas de distribuição e prontas para execução imediata em qualquer ambiente UNIX.

> ℹ️ **Automações Windows (.cmd / .ps1):** As receitas equivalentes para Windows residem em [`../windows/native/`](../windows/native/README.md).

---

## 📂 Catálogo de Recursos

| Recurso                                      | Tipo        | Descrição                                                                                          |
| :------------------------------------------- | :---------- | :------------------------------------------------------------------------------------------------- |
| **[`cli/`](cli/README.md)**                  | Receita     | Utilitários modernos de terminal (`core.sh`: bat, eza, fd, ripgrep, zoxide, fastfetch)             |
| **[`vcs/`](vcs/README.md)**                  | Receitas    | Instalação (`tools.sh`) e configuração global do Git (`git.sh`) e Game of Trees (`got.sh`)         |
| **[`editors/`](editors/README.md)**          | Subcatálogo | Instalação (`install.sh`), perfis pessoais (`editors.sh`) e frameworks (`lazyvim.sh`, etc.)        |
| **[`graphics/`](graphics/README.md)**        | Receitas    | Janelas (`windowing.sh`), Shaders (`shaders.sh`) e Suite 3D (`blender.sh`: Blender)                |
| **[`wasm/`](wasm/README.md)**                | Receita     | Compilador WebAssembly (`emscripten.sh`: C/C++ para Wasm)                                          |
| **[`media/`](media/README.md)**              | Receita     | Processamento de mídia (`cli.sh`: FFmpeg, ImageMagick, yt-dlp)                                     |
| **[`docs/`](docs/README.md)**                | Receita     | Editoração técnica e tipografia (`typesetting.sh`: Pandoc, TeX Live, PDFtk)                        |
| **[`ai/`](ai/README.md)**                    | Receita     | Inteligência artificial local (`ollama.sh`: inferência Ollama e SDK Python)                        |
| **[`security/`](security/README.md)**        | Receitas    | Análise binária (`re.sh`) e captura de pacotes (`wireshark.sh`)                                    |
| **[`fonts/`](fonts/README.md)**              | Receita     | Instalação de fontes tipográficas essenciais (`JetBrainsMono`, `RobotoMono`, `MesloLGS NF`)        |
| **[`linters/`](linters/README.md)**          | Receitas    | Implantação de formatadores (`linters.sh`), Prettier (`prettier.sh`) e Mermaid (`mermaid.sh`)      |
| **[`office/`](office/README.md)**            | Receita     | Suíte de escritório Collabora Office Desktop (`collabora.sh`) com dispatch universal               |
| **[`iso/`](iso/README.md)**                  | Subcatálogo | Imagens ISO dinâmicas e checksums oficiais (`debian`, `freebsd`, `openbsd`, `netbsd`, `dragonfly`) |
| **[`system/nopass.sh`](system/nopass.sh)**   | Receita     | Elevação de privilégios (`doas` + `sudo`) **sem senha** (0440)                                     |
| **[`system/persist.sh`](system/persist.sh)** | Receita     | Elevação de privilégios (`doas` + `sudo`) **com senha e sessão de 5 minutos** (0440)               |
| **[`system/strict.sh`](system/strict.sh)**   | Receita     | Elevação de privilégios (`doas` + `sudo`) **estrita (senha sempre / zero cache)** (0440)           |

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

# Instalar suite de criação 3D Blender
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/blender.sh | sh

# Instalar bibliotecas de janelas e multimídia (GLFW e SDL3)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/windowing.sh | sh

# Configurar Git
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/vcs/git.sh | sh
```
