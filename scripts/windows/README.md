# 🪟 Windows Tweaks & Registry Scripts

> Scripts e arquivos `.reg` para ajustes de sistema, ativação de Hyper-V e menus de contexto no Windows.

---

## 🎯 Finalidade

Esta pasta centraliza modificações cirúrgicas para o sistema operacional Windows:

- **Ativação de Hyper-V:** Habilita o subsistema de virtualização nativo da Microsoft via pacotes do DISM (inclusive em edições Home).
- **Ajustes de Registro (`registry/`):** Tweak de codificação UTF-8 global no CMD, mapeamento de teclado AltGr e atalhos no menu de contexto do Explorer.

---

## 📂 Catálogo de Arquivos

| Arquivo / Pasta                                    | Tipo                | Descrição                                                             |
| :------------------------------------------------- | :------------------ | :-------------------------------------------------------------------- |
| [`hyper-v.cmd`](hyper-v.cmd)                       | Script Batch CMD    | Força a instalação dos pacotes Hyper-V via DISM e habilita o recurso  |
| [`registry/utf8.reg`](registry/utf8.reg)           | Registro do Windows | Força Code Page 65001 (UTF-8) nativa no prompt de comando (`cmd.exe`) |
| [`registry/altgr2alt.reg`](registry/altgr2alt.reg) | Registro do Windows | Mapeia a tecla AltGr para funcionar como tecla Alt padrão             |
| [`registry/emacs.reg`](registry/emacs.reg)         | Registro do Windows | Adiciona a opção "Open with Emacs" no menu de contexto de arquivos    |
| [`registry/gcc.reg`](registry/gcc.reg)             | Registro do Windows | Adiciona atalhos de compilação rápida via GCC no menu de contexto     |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

1. Para ativar o **Hyper-V**, abra o Prompt de Comando como Administrador e execute os comandos de [`hyper-v.cmd`](hyper-v.cmd).
2. Para aplicar qualquer tweak de registro, baixe ou visualize o arquivo `.reg` desejado em `registry/`, clique com o botão direito no Windows e selecione **Mesclar (Merge)**.
