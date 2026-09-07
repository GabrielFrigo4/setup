# 🪟 MSYS2 UCRT64 — Catálogo de Receitas

> Receitas modulares para provisionamento do ambiente nativo de compilação MSYS2 (UCRT64) no Windows.

---

## 🎯 Finalidade

Esta pasta centraliza as receitas de provisionamento para o ambiente **MSYS2 UCRT64** (Universal C Runtime), fornecendo compilação nativa Win32/x86_64 de alto desempenho sem overhead de virtualização.

---

## 📂 Catálogo de Receitas

| Recurso             | Receita                          | Descrição                                                                           |
| :------------------ | :------------------------------- | :---------------------------------------------------------------------------------- |
| **`system.sh`**     | [`system.sh`](system.sh)         | Sistema base, shell padrão Bash, coreutils, Make e ferramentas cross                |
| **`tools.sh`**      | [`tools.sh`](tools.sh)           | Utilitários modernos de CLI (Git, GitHub CLI, bat, eza, ripgrep, fastfetch, ffmpeg) |
| **`editors.sh`**    | [`editors.sh`](editors.sh)       | Editores de terminal (Emacs nativo e Micro)                                         |
| **`toolchains.sh`** | [`toolchains.sh`](toolchains.sh) | Compiladores nativos (GCC, Clang/LLVM, Ninja, CMake, NASM, AVR)                     |
| **`languages.sh`**  | [`languages.sh`](languages.sh)   | Runtimes de Python (+ pip/uv/wheels), Lua (+ Luarocks) e Rust (+ toolchains GNU)    |
| **`graphics.sh`**   | [`graphics.sh`](graphics.sh)     | Frameworks GUI (GTK3/4, Qt5/6) e gamedev (Raylib, SDL2, SDL3, Vulkan, GLFW)         |
| **`libraries.sh`**  | [`libraries.sh`](libraries.sh)   | Bibliotecas de sistema e runtime (OpenSSL, Zstd, SQLite3, Libuv, Libarchive)        |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Abra o terminal do MSYS2 (UCRT64) e execute qualquer receita diretamente:

```sh
# Instalar toolchains de compilação
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/windows/msys2/toolchains.sh | sh

# Instalar linguagens (Python, Lua, Rust)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/windows/msys2/languages.sh | sh
```
