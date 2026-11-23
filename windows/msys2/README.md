# 🪟 MSYS2 UCRT64 — Catálogo de Receitas

> Receitas modulares para provisionamento do ambiente nativo de compilação MSYS2 (UCRT64) no Windows.

---

## 🎯 Finalidade

Esta pasta centraliza as receitas de provisionamento para o ambiente **MSYS2 UCRT64** (Universal C Runtime), todas integradas à biblioteca semântica [`core/ui.sh`](../../core/ui.sh) para saída padronizada e idempotente.

---

## 📂 Catálogo de Receitas

| Recurso             | Receita                          | Descrição                                                                                                                                  |
| :------------------ | :------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------- |
| **`system.sh`**     | [`system.sh`](system.sh)         | Sistema base, `SHELL=/usr/bin/bash` idempotente, coreutils, Make e ferramentas cross                                                       |
| **`tools.sh`**      | [`tools.sh`](tools.sh)           | Utilitários modernos de CLI (Git, GitHub CLI, bat, eza, ripgrep, zoxide, fastfetch, ffmpeg)                                                |
| **`editors.sh`**    | [`editors.sh`](editors.sh)       | Editores de terminal (Emacs nativo e Micro)                                                                                                |
| **`toolchains.sh`** | [`toolchains.sh`](toolchains.sh) | Compiladores nativos (GCC, Clang/LLVM, Emscripten, Ninja, CMake, NASM, AVR)                                                                |
| **`languages.sh`**  | [`languages.sh`](languages.sh)   | Runtimes de Python (+ pip/uv, PyQt6, OpenCV, NumPy, Pillow, Rich, Textual, docx, tqdm, Ollama), Lua (+ Luarocks) e Rust (+ toolchains GNU) |
| **`graphics.sh`**   | [`graphics.sh`](graphics.sh)     | Frameworks GUI (GTK3/4, Qt5/6) e gamedev (Raylib, SDL2, SDL3 + mixer/net, Vulkan, GLFW)                                                    |
| **`libraries.sh`**  | [`libraries.sh`](libraries.sh)   | Bibliotecas de sistema e runtime (OpenSSL, Zstd, SQLite3, Libuv, Libarchive)                                                               |

---

## 🚀 Como Executar (MSYS2 UCRT64)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/windows/msys2/system.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/windows/msys2/toolchains.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/windows/msys2/languages.sh"
```
