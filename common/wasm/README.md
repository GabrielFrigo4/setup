# 🌐 Common WebAssembly Toolchains

> Receitas universais em POSIX Shell para toolchains e compiladores WebAssembly.

---

## 🎯 Finalidade

Esta pasta centraliza a instalação e configuração de compiladores WebAssembly, notadamente o **Emscripten** (`emcc`, `em++`).

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita                | Descrição                                           | Plataforma                                  |
| :------------------------------- | :-------------------------------------------------- | :------------------------------------------ |
| [`emscripten.sh`](emscripten.sh) | Compilador WebAssembly Emscripten (C/C++ para Wasm) | Linux / FreeBSD / macOS / WSL / MSYS2 / Win |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/wasm/emscripten.sh"
```
