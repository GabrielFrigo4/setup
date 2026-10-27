# 🌐 Bootstrap Common (Multiplataforma POSIX) — Catálogo de Receitas

> Receitas modulares e universais em POSIX Shell (`.sh`) compartilhadas entre Linux, FreeBSD, macOS, WSL2 e MSYS2.

---

## 🎯 Finalidade

Esta pasta abriga receitas de automação que são **100% puras em POSIX Shell (`.sh`)**, agnósticas de distribuição e prontas para execução imediata em qualquer ambiente UNIX.

> ℹ️ **Automações Windows (.cmd / .ps1):** As receitas equivalentes para Windows residem em [`../windows/native/`](../windows/native/README.md).

---

## 📂 Catálogo de Recursos

| Recurso                                 | Tipo        | Descrição                                                                                                     |
| :-------------------------------------- | :---------- | :------------------------------------------------------------------------------------------------------------ |
| **[`cli/`](cli/README.md)**             | Receitas    | Utilitários modernos de terminal (`core.sh`: bat, eza, fd, ripgrep, zoxide, fastfetch) e multiplexadores      |
| **[`database/`](database/README.md)**   | Receitas    | Motores e clientes de banco de dados (`databases.sh`: PostgreSQL, SQLite, MariaDB, MySQL, MongoDB, Redis)     |
| **[`vcs/`](vcs/README.md)**             | Receitas    | Instalação (`tools.sh`) e configuração global do Git (`git.sh`) e Game of Trees (`got.sh`)                    |
| **[`editors/`](editors/README.md)**     | Subcatálogo | Instalação (`install.sh`), perfis pessoais (`editors.sh`) e frameworks (`lazyvim.sh`, etc.)                   |
| **[`graphics/`](graphics/README.md)**   | Receitas    | Janelas (`windowing.sh`), Shaders (`shaders.sh`) e Suite 3D (`blender.sh`: Blender)                           |
| **[`wasm/`](wasm/README.md)**           | Receita     | Compilador WebAssembly (`emscripten.sh`: C/C++ para Wasm)                                                     |
| **[`media/`](media/README.md)**         | Receitas    | Processamento de mídia (`cli.sh`: FFmpeg, ImageMagick, yt-dlp) e reprodutores (`players.sh`)                  |
| **[`docs/`](docs/README.md)**           | Receita     | Editoração técnica e tipografia (`typesetting.sh`: Pandoc, TeX Live, PDFtk)                                   |
| **[`ai/`](ai/README.md)**               | Receita     | Inteligência artificial local (`ollama.sh`: inferência Ollama e SDK Python)                                   |
| **[`security/`](security/README.md)**   | Receitas    | Análise binária (`re.sh`) e captura de pacotes (`wireshark.sh`)                                               |
| **[`languages/`](languages/README.md)** | Receitas    | Toolchains de linguagens (`rust-ewm.sh`: Cargo, Rustc e dependências DRM/Wayland)                             |
| **[`fonts/`](fonts/README.md)**         | Receitas    | Instalação de fontes tipográficas essenciais (`JetBrainsMono`, `RobotoMono`, `MesloLGS NF`, `Terminus`)       |
| **[`linters/`](linters/README.md)**     | Receitas    | Implantação de formatadores (`linters.sh`), Prettier (`prettier.sh`), Ruff (`ruff.sh`) e Mermaid              |
| **[`office/`](office/README.md)**       | Receita     | Suíte de escritório Collabora Office Desktop (`collabora.sh`) com dispatch universal                          |
| **[`web/`](web/README.md)**             | Receita     | Instalação multiplataforma de navegadores web (`browsers.sh`)                                                 |
| **[`workspace/`](workspace/README.md)** | Receita     | Provisionamento e estruturação de diretórios de trabalho (`workspace.sh`)                                     |
| **[`iso/`](iso/README.md)**             | Subcatálogo | Imagens ISO dinâmicas e checksums oficiais (Alpine, Arch, Debian, Devuan, Fedora, Void, FreeBSD, BSDs)        |
| **[`system/`](system/README.md)**       | Receitas    | Políticas de elevação `doas` + `sudo`: sem senha (`nopass.sh`), sessão (`persist.sh`) e estrito (`strict.sh`) |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Configurar privilégios sem senha (Desktop):

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/nopass.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/nopass.sh) | sh
```

Configurar privilégios com sessão salva (Servidor / VPS):

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/persist.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/persist.sh) | sh
```

Configurar privilégios com senha sempre (Servidor Crítico / Estrito):

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/strict.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/system/strict.sh) | sh
```

Instalar fontes universais:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/fonts/fonts.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/fonts/fonts.sh) | sh
```

Configurar formatadores e linters globais:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/linters.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/linters.sh) | sh
```

Provisionar suíte de bancos de dados:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/databases.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/databases.sh) | sh
```

Instalar suite de criação 3D Blender:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/blender.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/blender.sh) | sh
```

Instalar bibliotecas de janelas e multimídia (GLFW e SDL3):

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/windowing.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/windowing.sh) | sh
```

Configurar Git:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/vcs/git.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/vcs/git.sh) | sh
```
