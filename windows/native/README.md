# 🖥️ Windows Native — Ferramentas, Editores, Linters & Segurança

> Receitas modulares e automações para o ambiente nativo do Windows (sem virtualização).

---

## 🎯 Finalidade

Reúne todo o ferramental de provisionamento nativo para estações de trabalho Windows:

- **Editores & Frameworks:** Perfis pessoais (`editors.cmd`), frameworks (`doom-emacs.cmd`, `lazyvim.cmd`, `spacevim.cmd`), temas e sincronizador de extensões (`sync-extensions.ps1`).
- **Fontes do Sistema:** Instalação de Nerd Fonts e fontes tipográficas via PowerShell (`fonts.ps1`).
- **Linters & Formatadores:** Implantação de `.clang-format`, `.prettierrc`, `.stylua.toml` e `clangd` (`linters.cmd`).
- **Controle de Versão:** Configuração global do Git e Got (`vcs/`).
- **Gerenciadores de Pacotes:** Automações para Winget, Scoop e Chocolatey (`pkg/`).
- **Suite de Engenharia Reversa:** Ferramental portátil curado (`security/`).
- **Ferramentas de Desenvolvimento:** Pacotes oficiais (Visual Studio, Windows Terminal, Sysinternals).

---

## 📂 Catálogo Categorizado

| Subdiretório / Arquivo | Tipo                                                         | Descrição                                                                         |
| :--------------------- | :----------------------------------------------------------- | :-------------------------------------------------------------------------------- |
| **`editors/`**         | [`editors/editors.cmd`](editors/editors.cmd)                 | Clona e atualiza perfis pessoais de editores (Neovim, Emacs, Vim, Helix, Micro)   |
| **`editors/`**         | [`editors/sync-extensions.ps1`](editors/sync-extensions.ps1) | Sincroniza em lote a lista declarativa `extensions.txt` no VS Code ou Antigravity |
| **`editors/`**         | [`editors/doom-emacs.cmd`](editors/doom-emacs.cmd)           | Setup completo do Doom Emacs no Windows                                           |
| **`editors/`**         | [`editors/lazyvim.cmd`](editors/lazyvim.cmd)                 | Setup completo do LazyVim no Windows                                              |
| **`editors/`**         | [`editors/spacevim.cmd`](editors/spacevim.cmd)               | Setup completo do SpaceVim no Windows                                             |
| **`editors/`**         | [`editors/themes.cmd`](editors/themes.cmd)                   | Temas One Dark (Geany), Dracula (Micro) e Vim-Plug                                |
| **`fonts/`**           | [`fonts/fonts.ps1`](fonts/fonts.ps1)                         | Baixa e registra Nerd Fonts (`JetBrainsMono`, `MesloLGS`) no Windows              |
| **`linters/`**         | [`linters/linters.cmd`](linters/linters.cmd)                 | Implanta `.clang-format`, `.prettierrc`, `.stylua.toml` e `config.yaml` do Clangd |
| **`vcs/`**             | [`vcs/git.cmd`](vcs/git.cmd)                                 | Configuração global do Git com padrões recomendados                               |
| **`vcs/`**             | [`vcs/got.cmd`](vcs/got.cmd)                                 | Gera `%USERPROFILE%\.gotconfig` no Windows                                        |
| **`pkg/`**             | [`pkg/winget.cmd`](pkg/winget.cmd)                           | Instalação curada de softwares essenciais via Windows Package Manager             |
| **`pkg/`**             | [`pkg/scoop.cmd`](pkg/scoop.cmd)                             | Setup do Scoop com buckets `extras` e ferramentas portáteis                       |
| **`pkg/`**             | [`pkg/choco.cmd`](pkg/choco.cmd)                             | Setup do Chocolatey                                                               |
| **`security/`**        | [`security/ghidra.cmd`](security/ghidra.cmd)                 | Instalação automatizada do Ghidra SRE (NSA) portátil                              |
| **`security/`**        | [`security/binaries.cmd`](security/binaries.cmd)             | Utilitários de análise de binários (XPEViewer, XELFViewer, Detect It Easy)        |
| **`security/`**        | [`security/debuggers.cmd`](security/debuggers.cmd)           | Instalação e plugins do x64dbg Plugin Manager                                     |
| **`security/`**        | [`security/assemblers.cmd`](security/assemblers.cmd)         | Flat Assembler Suite (FASM, FASMG, FASMARM)                                       |
| **`security/`**        | [`security/ropgadget.cmd`](security/ropgadget.cmd)           | Wrapper para chamadas do ROPgadget no Prompt de Comando                           |
| **`dev-tools.cmd`**    | [`dev-tools.cmd`](dev-tools.cmd)                             | Visual Studio Community, Windows Terminal, PowerToys e Sysinternals               |
| **`setup.ps1`**        | [`setup.ps1`](setup.ps1)                                     | Módulos para PowerShell e atalhos de inicialização rápida do Emacs Daemon         |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Abra o arquivo desejado no GitHub e copie os blocos de comandos diretamente em um terminal com privilégios de Administrador.
