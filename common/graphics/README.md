# 🎨 Common Graphics, Windowing & Shaders

> Receitas universais em POSIX Shell para bibliotecas gráficas, gerenciamento de janelas e toolchains de shaders no Host.

---

## 🎯 Finalidade

Esta pasta centraliza receitas universais para bibliotecas de janelas e multimídia gráfica (**GLFW**, **SDL3**, ecossistema **SDL3_image**, **SDL3_net**, **SDL3_ttf**, **SDL3_mixer**, **SDL_gpu_shadercross**), compiladores de shaders modernos (**Vulkan SDK**, **SPIR-V Tools**, **SPIRV-Cross**, **Slang**, **DXC**, **glslang** e **shaderc**) e a suite de criação e modelagem 3D (**Blender**).

> ℹ️ **Toolchains WebAssembly:** A receita do compilador Emscripten reside em [`../wasm/emscripten.sh`](../wasm/emscripten.sh).

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita                  | Descrição                                                                                                               | Plataforma                            |
| :--------------------------------- | :---------------------------------------------------------------------------------------------------------------------- | :------------------------------------ |
| [`windowing.sh`](windowing.sh)     | Bibliotecas de janelas e multimídia gráfica (GLFW, SDL3 e ecossistema)                                                  | Linux / FreeBSD / macOS / WSL / MSYS2 |
| [`xorg.sh`](xorg.sh)               | Servidor Xorg, WMs X11 (`openbox`, `cwm`, `fvwm3`/`fvwm`, `fluxbox`, `icewm`, etc.), `20-tearfree.conf` e `30-tap.conf` | Linux / FreeBSD / Arch                |
| [`compositors.sh`](compositors.sh) | Compositores Wayland (`sway`, `river`, `labwc`, `cage`, `wayfire`, `niri`, `hikari`, `weston`), `wofi`, `foot`          | Linux / FreeBSD / Arch                |
| [`shaders.sh`](shaders.sh)         | Compiladores de shaders modernos (Vulkan SDK, Slang, DXC, glslang, shaderc, SPIRV-Cross)                                | Linux / FreeBSD / MSYS2               |
| [`blender.sh`](blender.sh)         | Suite completa de modelagem, animação e renderização 3D (Blender)                                                       | Linux / FreeBSD / Windows (Winget)    |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/graphics/blender.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/graphics/windowing.sh"
```
