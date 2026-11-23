# 🛠️ Common Languages & Development Toolchains

> Receitas universais em POSIX Shell para linguagens de programação e toolchains de compilação.

---

## 🎯 Finalidade

Esta pasta centraliza receitas de instalação e configuração de toolchains de linguagens de programação e suas respectivas dependências de sistema para compilação nativa.

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita            | Descrição                                                                                 | Plataforma                    |
| :--------------------------- | :---------------------------------------------------------------------------------------- | :---------------------------- |
| [`rust-ewm.sh`](rust-ewm.sh) | Toolchain Rust (Cargo/Rustc) e bibliotecas DRM/Wayland para módulos nativos do EWM        | Linux / FreeBSD / Arch        |
| [`python.sh`](python.sh)     | Stack Python (PyQt6, Rich, Textual, OpenCV, NumPy, Pillow, python-docx, tqdm, SDK Ollama) | Linux / FreeBSD / MSYS2 / Win |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/languages/rust-ewm.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/languages/python.sh"
```
