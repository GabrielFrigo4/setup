# 🎨 Common Graphics, Windowing & Shaders

> Receitas universais em POSIX Shell para bibliotecas gráficas, gerenciamento de janelas e toolchains de shaders no Host.

---

## 🎯 Finalidade

Esta pasta centraliza receitas universais para bibliotecas de janelas e multimídia gráfica (**GLFW**, **SDL3**, ecossistema **SDL3_image**, **SDL3_net**, **SDL3_ttf**, **SDL3_mixer**, **SDL_gpu_shadercross**), compiladores de shaders modernos (**Vulkan SDK**, **SPIR-V Tools**, **SPIRV-Cross**, **Slang**, **DXC**, **glslang** e **shaderc**) e a suite de criação e modelagem 3D (**Blender**).

> ℹ️ **Toolchains WebAssembly:** A receita do compilador Emscripten reside em [`../wasm/emscripten.sh`](../wasm/emscripten.sh).

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita                  | Descrição                                                                                | Plataforma                            |
| :--------------------------------- | :--------------------------------------------------------------------------------------- | :------------------------------------ |
| [`windowing.sh`](windowing.sh)     | Bibliotecas de janelas e multimídia gráfica (GLFW, SDL3 e ecossistema)                   | Linux / FreeBSD / macOS / WSL / MSYS2 |
| [`compositors.sh`](compositors.sh) | Tétrade de micro-compositores Wayland (Sway, River, Labwc, Cage), Seatd e Foot           | Linux / FreeBSD / Arch                |
| [`shaders.sh`](shaders.sh)         | Compiladores de shaders modernos (Vulkan SDK, Slang, DXC, glslang, shaderc, SPIRV-Cross) | Linux / FreeBSD / MSYS2               |
| [`blender.sh`](blender.sh)         | Suite completa de modelagem, animação e renderização 3D (Blender)                        | Linux / FreeBSD / Windows (Winget)    |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Provisionar suite de modelagem e animação 3D Blender:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/blender.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/blender.sh) | sh
```

Provisionar bibliotecas de janelas e multimídia (GLFW e SDL3):

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/windowing.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/graphics/windowing.sh) | sh
```
