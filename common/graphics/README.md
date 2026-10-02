# 🎨 Common Graphics, Windowing & Shaders

> Receitas universais em POSIX Shell para bibliotecas gráficas, gerenciamento de janelas e toolchains de shaders no Host.

---

## 🎯 Finalidade

Esta pasta centraliza receitas universais para bibliotecas de janelas e multimídia gráfica (**GLFW**, **SDL3**, ecossistema **SDL3_image**, **SDL3_net**, **SDL3_ttf**, **SDL3_mixer**, **SDL_gpu_shadercross**) e compiladores de shaders modernos (**Vulkan SDK**, **SPIR-V Tools**, **SPIRV-Cross**, **Slang**, **DXC**, **glslang** e **shaderc**).

> ℹ️ **Toolchains WebAssembly:** A receita do compilador Emscripten reside em [`../wasm/emscripten.sh`](../wasm/emscripten.sh).

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita              | Descrição                                                                                | Plataforma                            |
| :----------------------------- | :--------------------------------------------------------------------------------------- | :------------------------------------ |
| [`windowing.sh`](windowing.sh) | Bibliotecas de janelas e multimídia gráfica (GLFW, SDL3 e ecossistema)                   | Linux / FreeBSD / macOS / WSL / MSYS2 |
| [`shaders.sh`](shaders.sh)     | Compiladores de shaders modernos (Vulkan SDK, Slang, DXC, glslang, shaderc, SPIRV-Cross) | Linux / FreeBSD / MSYS2               |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute diretamente no terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/windowing.sh | sh
```
