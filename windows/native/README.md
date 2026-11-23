# 🖥️ Windows Native — Pacotes Declarativos, Registro & Segurança

> Receitas modulares, manifestos declarativos e automações para o ambiente nativo do Windows.

---

## 🎯 Finalidade

Reúne o ferramental de provisionamento nativo para estações de trabalho Windows:

- **Gerenciadores de Pacotes (`pkg/`):** Manifesto declarativo [`winget.json`](pkg/winget.json) importado via [`winget.cmd`](pkg/winget.cmd) e bootstrap idempotente [`scoop.cmd`](pkg/scoop.cmd).
- **Registro & Virtualização (`registry/`, `hyper-v.cmd`):** Ajustes UTF-8 (`65001`), mapeamento AltGr $\rightarrow$ Alt, integração Emacs/GCC e habilitação do Hyper-V.
- **Fontes & Shell:** Instalação de Nerd Fonts via PowerShell (`fonts.ps1`) e Oh-My-Posh (`shell/`).
- **Linguagens & Escritório:** Stack Python 3.14 (`languages/python.cmd`), LibreOffice (`office/libreoffice.cmd`) e Collabora Office (`office/collabora.cmd`).
- **Suite de Engenharia Reversa (`security/`):** Ghidra SRE, XPE/XELFViewer, x64dbg, FASM e ROPgadget.
- **PowerShell Setup (`setup.ps1`):** Módulos PowerShell, faixa dinâmica WinNAT IANA e atalhos em `Start Menu\Programs\Custom`.

---

## 📂 Catálogo Categorizado

| Subdiretório / Arquivo | Arquivo                                              | Descrição                                                                                   |
| :--------------------- | :--------------------------------------------------- | :------------------------------------------------------------------------------------------ |
| **`pkg/winget.json`**  | [`pkg/winget.json`](pkg/winget.json)                 | Manifesto declarativo oficial de pacotes Winget e Microsoft Store                           |
| **`pkg/winget.cmd`**   | [`pkg/winget.cmd`](pkg/winget.cmd)                   | Importa `winget.json` (`winget import`) e fixa toolchains essenciais (`winget pin`)         |
| **`pkg/scoop.cmd`**    | [`pkg/scoop.cmd`](pkg/scoop.cmd)                     | Setup idempotente do Scoop com buckets e ferramentas portáteis                              |
| **`registry/`**        | [`registry/utf8.reg`](registry/utf8.reg)             | Força Code Page 65001 (UTF-8) global no Prompt de Comando (`cmd.exe`)                       |
| **`registry/`**        | [`registry/altgr2alt.reg`](registry/altgr2alt.reg)   | Mapeia a tecla AltGr para funcionar como tecla Alt esquerda                                 |
| **`registry/`**        | [`registry/emacs.reg`](registry/emacs.reg)           | Associação `.el` e menu de contexto para `emacsclientw.exe`                                 |
| **`registry/`**        | [`registry/gcc.reg`](registry/gcc.reg)               | Variáveis de inclusão e biblioteca para toolchains MSYS2                                    |
| **`hyper-v.cmd`**      | [`hyper-v.cmd`](hyper-v.cmd)                         | Instala pacotes DISM e habilita o recurso Microsoft-Hyper-V                                 |
| **`fonts/`**           | [`fonts/fonts.ps1`](fonts/fonts.ps1)                 | Baixa e registra Carlito e Nerd Fonts (`JetBrainsMono`, `RobotoMono`, `MesloLGS`)           |
| **`shell/`**           | [`shell/oh-my-posh.cmd`](shell/oh-my-posh.cmd)       | Instalação do binário Oh-My-Posh via Winget                                                 |
| **`security/`**        | [`security/ghidra.cmd`](security/ghidra.cmd)         | Instalação automatizada do Ghidra SRE (NSA) portátil                                        |
| **`security/`**        | [`security/binaries.cmd`](security/binaries.cmd)     | Utilitários de análise de binários (XPEViewer, XELFViewer, Detect It Easy)                  |
| **`security/`**        | [`security/debuggers.cmd`](security/debuggers.cmd)   | Instalação e plugins do x64dbg Plugin Manager                                               |
| **`security/`**        | [`security/assemblers.cmd`](security/assemblers.cmd) | Flat Assembler Suite (FASM, FASMG, FASMARM)                                                 |
| **`security/`**        | [`security/ropgadget.cmd`](security/ropgadget.cmd)   | Wrapper para chamadas do ROPgadget no Prompt de Comando                                     |
| **`dev-tools.cmd`**    | [`dev-tools.cmd`](dev-tools.cmd)                     | Visual Studio Community, Windows Terminal, PowerToys, Sysinternals, CMake e `uv`            |
| **`languages/`**       | [`languages/python.cmd`](languages/python.cmd)       | Provisionamento do Python 3.14, `uv` e módulos TUI/GUI/Visão/Docs/Ollama via Winget e `pip` |
| **`llm/`**             | [`llm/ollama.cmd`](llm/ollama.cmd)                   | Instalação do servidor de inferência Ollama via Winget                                      |
| **`office/`**          | [`office/libreoffice.cmd`](office/libreoffice.cmd)   | Provisionamento do LibreOffice Suite (`soffice.exe`) via Winget                             |
| **`office/`**          | [`office/collabora.cmd`](office/collabora.cmd)       | Provisionamento do Collabora Office Desktop via Winget / Microsoft Store                    |
| **`graphics/`**        | [`graphics/blender.cmd`](graphics/blender.cmd)       | Provisionamento do Blender 3D Suite via Winget                                              |
| **`shaders.cmd`**      | [`shaders.cmd`](shaders.cmd)                         | Toolchains de shaders (Vulkan SDK, DXC, Slang via winget/vcpkg)                             |
| **`setup.ps1`**        | [`setup.ps1`](setup.ps1)                             | Módulos PowerShell, WinNAT IANA e atalhos de inicialização rápida (Emacs & Ollama)          |

---

## 🚀 Como Executar

Execute a partir do clone local em um terminal com privilégios de Administrador:

```cmd
windows\native\pkg\winget.cmd
windows\native\pkg\scoop.cmd
powershell -ExecutionPolicy Bypass -File windows\native\setup.ps1
```
