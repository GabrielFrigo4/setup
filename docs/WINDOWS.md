# 🪟 O Ecossistema Windows

> Arquitetura do ambiente nativo Win32, engenharia reversa, subsistema MSYS2 (UCRT64) e integração com WSL2.

---

## 🎯 Visão Geral

O Windows opera neste repositório sob uma abordagem pragmática e especializada: aproveitamos as ferramentas certas para cada contexto sem forçar o Windows a se comportar como um Unix falso, dividindo a atuação em três camadas complementares:

1. **Camada Nativa (`native/`):** Gerenciadores de pacotes oficiais, suite de engenharia reversa e ferramentas de compilação Microsoft Visual C++ (MSVC).
2. **Subsistema MSYS2 (`msys2/`):** Toolchains GNU/LLVM nativas (UCRT64) com gerenciador `pacman` para compilação C/C++/Rust de altíssimo desempenho sem virtualização.
3. **Subsistema WSL2 (`linux/wsl/`):** Instâncias de kernels Linux reais (Arch Linux, Debian, Fedora) sob hypervisor para desenvolvimento conteinerizado.

---

## 🏗️ 1. Windows Nativo (`bootstrap/windows/native/`)

A camada nativa provê softwares portáteis e ferramentas de sistema integradas ao Windows:

### A. Gerenciadores de Pacotes

- **Winget (Windows Package Manager):** Gerenciador primário oficial ([`pkg/winget.cmd`](../bootstrap/windows/native/pkg/winget.cmd)) para navegadores, IDEs e utilitários de sistema.
- **Scoop:** Gerenciador voltado para ferramentas de linha de comando portáteis instaladas no espaço do usuário sem privilégios de Administrador ([`pkg/scoop.cmd`](../bootstrap/windows/native/pkg/scoop.cmd)).
- **Chocolatey:** Contingência para pacotes legados ([`pkg/choco.cmd`](../bootstrap/windows/native/pkg/choco.cmd)).

### B. Suite de Engenharia Reversa e Análise de Binários

A pasta [`security/`](../bootstrap/windows/native/security/) concentra ferramentas essenciais para análise de malware, engenharia reversa e auditoria de binários PE/ELF:

- **Ghidra SRE (NSA):** Framework profissional de descompilação Java/C++.
- **x64dbg:** Depurador de binários de 32 e 64 bits com gerenciador de plugins.
- **Ferramentas de Análise:** XPEViewer, XELFViewer e Detect It Easy (DIE).
- **Suite Flat Assembler (FASM):** Compiladores Assembly x86/x64 e ARM.
- **ROPgadget:** Analisador de gadgets ROP/JOP para exploração de binários.

### C. Configuração e Automações PowerShell

- **[`setup.ps1`](../bootstrap/windows/native/setup.ps1):** Instalação de módulos essenciais (`PSWindowsUpdate`, `Terminal-Icons`, `NerdFonts`) e criação de atalhos de inicialização rápida para o **Emacs Daemon** (`emacsclientw.exe`).

---

## ⚡ 2. Subsistema MSYS2 UCRT64 (`bootstrap/windows/msys2/`)

O **MSYS2 UCRT64** provê um ambiente de desenvolvimento POSIX completo que compila código nativo Win32/x86_64 utilizando o _Universal C Runtime_ moderno da Microsoft:

- **Por que UCRT64?** Elimina os problemas de compatibilidade do antigo `MSVCRT.dll` e fornece suporte completo a UTF-8, C17/C23, C++23 e toolchains LLVM/Clang modernas.
- **Zero Overhead:** Os binários gerados pelo MSYS2 rodam nativamente no Windows sem camadas de emulação ou dependência de daemons.

### Catálogo de Receitas Temáticas do MSYS2:

- [`system.sh`](../bootstrap/windows/msys2/system.sh) — Sistema base, coreutils, Make e shell padrão Bash.
- [`tools.sh`](../bootstrap/windows/msys2/tools.sh) — Git, GitHub CLI, bat, eza, ripgrep, fastfetch e ffmpeg.
- [`editors.sh`](../bootstrap/windows/msys2/editors.sh) — Emacs nativo e Micro.
- [`toolchains.sh`](../bootstrap/windows/msys2/toolchains.sh) — GCC, Clang/LLVM, Ninja, CMake, NASM e toolchain AVR/Embedded.
- [`languages.sh`](../bootstrap/windows/msys2/languages.sh) — Runtimes de Python (+ uv/pip), Lua (+ Luarocks) e Rust (+ toolchains GNU).
- [`graphics.sh`](../bootstrap/windows/msys2/graphics.sh) — Frameworks GUI (GTK3/4, Qt5/6) e gamedev (Raylib, SDL2, SDL3, Vulkan, GLFW).
- [`libraries.sh`](../bootstrap/windows/msys2/libraries.sh) — OpenSSL, Zstd, SQLite3, Libuv e Tree-sitter.

---

## 🔧 3. Tweaks de Registro e Sistema (`scripts/windows/`)

Para garantir a melhor experiência no terminal e compatibilidade com padrões globais:

- **[`registry/utf8.reg`](../scripts/windows/registry/utf8.reg):** Força o Prompt de Comando (CMD) a usar a página de código UTF-8 (`chcp 65001`) por padrão.
- **[`registry/altgr2alt.reg`](../scripts/windows/registry/altgr2alt.reg):** Mapeamento do teclado para transformar a tecla AltGr em Alt esquerdo, facilitando atalhos em editores como Emacs e Vim.
- **[`hyper-v.cmd`](../scripts/windows/hyper-v.cmd):** Ativação e configuração do hypervisor Hyper-V e subsistema de virtualização da Microsoft.
