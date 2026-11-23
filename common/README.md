# 🌐 Bootstrap Common (Multiplataforma POSIX) — Catálogo de Receitas

> Receitas modulares e universais em POSIX Shell (`.sh`) compartilhadas entre Linux, FreeBSD, macOS, WSL2 e MSYS2.

---

## 🎯 Finalidade

Esta pasta abriga receitas de automação que são **100% puras em POSIX Shell (`.sh`)**, agnósticas de distribuição e prontas para execução imediata a partir do clone soberano (`~/.local/share/setup`).

> ℹ️ **Automações Windows (.cmd / .ps1):** As receitas equivalentes para Windows residem em [`../windows/native/`](../windows/native/README.md).

---

## 📂 Catálogo de Recursos

| Recurso                                 | Tipo        | Descrição                                                                                                                                                   |
| :-------------------------------------- | :---------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **[`cli/`](cli/README.md)**             | Receitas    | Utilitários modernos de terminal (`core.sh`: bat, eza, fd, ripgrep, zoxide, fastfetch), `bookokrat.sh` e multiplexadores                                    |
| **[`vcs/`](vcs/README.md)**             | Receitas    | Instalação de ferramentas (`tools.sh`: git, gh, git-lfs, got) e criptografia (`git-crypt.sh`)                                                               |
| **[`editors/`](editors/README.md)**     | Subcatálogo | Instalação de editores (`install.sh`) e compilação do módulo Wayland EWM (`ewm.sh`)                                                                         |
| **[`graphics/`](graphics/README.md)**   | Receitas    | Xorg/WMs (`xorg.sh`), Wayland (`compositors.sh`), Janelas (`windowing.sh`), Shaders (`shaders.sh`) e Blender                                                |
| **[`wasm/`](wasm/README.md)**           | Receita     | Compilador WebAssembly (`emscripten.sh`: C/C++ para Wasm)                                                                                                   |
| **[`media/`](media/README.md)**         | Receitas    | Processamento de mídia (`cli.sh`: FFmpeg, ImageMagick, yt-dlp) e reprodutores (`players.sh`)                                                                |
| **[`docs/`](docs/README.md)**           | Receita     | Editoração técnica e tipografia (`typesetting.sh`: Pandoc, TeX Live, PDFtk)                                                                                 |
| **[`ai/`](ai/README.md)**               | Receita     | Inteligência artificial local (`ollama.sh`: inferência Ollama e SDK Python)                                                                                 |
| **[`security/`](security/README.md)**   | Receitas    | Análise binária (`re.sh`) e captura de pacotes (`wireshark.sh`)                                                                                             |
| **[`languages/`](languages/README.md)** | Receitas    | Toolchains e runtimes (`rust-ewm.sh`: Rust/DRM/Wayland; `python.sh`: PyQt6, Rich, Textual, OpenCV, NumPy, Pillow, docx, tqdm, Ollama)                       |
| **[`fonts/`](fonts/README.md)**         | Receitas    | Instalação de fontes tipográficas essenciais (`JetBrainsMono`, `RobotoMono`, `MesloLGS NF`, `Terminus`)                                                     |
| **[`linters/`](linters/README.md)**     | Receitas    | Instalação de formatadores e linters CLI: Prettier (`prettier.sh`), Ruff (`ruff.sh`) e Mermaid (`mermaid.sh`)                                               |
| **[`office/`](office/README.md)**       | Receitas    | Suítes de escritório LibreOffice (`office.sh`) e Collabora Office Desktop (`collabora.sh`) com dispatch universal (`pkg -> dnf -> apt -> pacman -> winget`) |
| **[`web/`](web/README.md)**             | Receita     | Instalação multiplataforma de navegadores web (`browsers.sh`)                                                                                               |
| **[`iso/`](iso/README.md)**             | Subcatálogo | Motor único [`download.sh`](iso/download.sh) com checksums oficiais (Alpine, Arch, Debian, Devuan, DragonFly, Fedora, FreeBSD, NetBSD, OpenBSD, Void)       |
| **[`system/`](system/README.md)**       | Receitas    | Políticas de elevação `doas` + `sudo`: sem senha (`nopass.sh`), sessão (`persist.sh`) e estrito (`strict.sh`)                                               |

---

## 🚀 Como Executar (Clone Soberano)

Execute receitas diretamente a partir do clone local (`~/.local/share/setup`) ou via orquestrador `setup.sh`:

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/nopass.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/persist.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/strict.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/fonts/fonts.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/graphics/blender.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/graphics/windowing.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/vcs/tools.sh"
```
