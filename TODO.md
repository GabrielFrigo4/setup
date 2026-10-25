# 🗺️ Roadmap & Status — Universal Setup

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> Arquitetura modular `core/`, elevação antifrágil, paridade multiplataforma (Linux, FreeBSD, Windows) e receitas idempotentes foram integralmente concluídas.

---

## 📊 Matriz de Maturidade

| Área                        |   Status    | Cobertura / Estado                                                         |
| :-------------------------- | :---------: | :------------------------------------------------------------------------- |
| **Linux Provisioning**      | 🟢 Estável  | Paridade Debian, Arch, Fedora, Void e Alpine com receitas idempotentes     |
| **FreeBSD Provisioning**    | 🟢 Estável  | Pacotes `pkg`, áudio OSS, DRM/KMS e Bhyve automatizados via `sysrc`        |
| **Windows Provisioning**    | 🟢 Estável  | Receitas nativas integradas via Winget e delegação ao motor do Shell       |
| **Console & TTY**           | 🟢 Estável  | Fontes KMS Terminus 16x32, teclados ABNT2/US e locale soberano UTF-8       |
| **Servidores Ubuntu**       | 🟢 Estável  | Baseline minimalista de servidor com apt-clone, tmux e full-upgrade        |
| **Orquestrador Central**    | 🟢 Estável  | `setup.sh` desacoplado em receitas atômicas e modulares em `core/`         |
| **Compositores Wayland**    | 🟢 Estável  | Tétrade `sway`, `river`, `labwc`, `cage` com `seatd`, `foot` e `wlr-randr` |
| **Ecossistema X11 / Xorg**  | 🟢 Estável  | Servidor Xorg, xinit, xterm, xrdb, xdotool e micro-WMs de quiosque         |
| **Mídia & Streaming**       | 🟢 Estável  | `mpv`, `vlc` e `yt-dlp` provisionados de forma cross-platform              |
| **Toolchain Rust & EWM**    | 🟢 Estável  | Compilação e setup de `libewm_core.so` e `ewm` Elisp via Smithay / Rust    |
| **Mouse no Console**        | 🟢 Estável  | Suporte a `gpm` (Linux) e `moused` ABNT2 acelerado (FreeBSD)               |
| **Segurança & Privilégios** | 🟢 Estável  | Detecção automática antifrágil de `sudo`/`doas` em `core/elevate.sh`       |
| **Emissão Visual TUI**      | 🟢 Estável  | Biblioteca semântica canônica `core/ui.sh` (`_ui_*`) integrada             |
| **Quality Gates**           | 🟢 Aprovado | Linters de monólitos, nanos, sintaxe POSIX e réguas 100% aprovados         |

---

## 🛡️ Atributos Entregues

- **Zero Pendências:** Sistema de provisionamento modular, idempotente e resiliente em 7 plataformas.
- **Tétrade de Micro-Compositores Wayland:** Receitas idempotentes para `sway`, `river`, `labwc`, `cage`, `seatd`, `foot` e `wlr-randr` em Linux e FreeBSD.
- **Players de Mídia Headless & Desktop:** `mpv`, `vlc` e `yt-dlp` provisionados de forma cross-platform.
- **Tipografia Terminus Console & TTF:** Suporte integrado a `terminus-fonts`, `terminus-fonts-console` e `terminus-ttf`.
- **Toolchain Rust & Headers C p/ EWM:** Instalação modular de `cargo`, `libinput`, `libxkbcommon`, `pixman`, `mesa-libgbm` e `hwdata`.
- **Mouse & Teclado no Console Kernel (Raw TTY):** Configuração de `gpm` no Linux e `moused` ABNT2 acelerado no FreeBSD.
- **Paridade Cross-Platform Winget:** Suporte a navegadores headless/desktop no Windows via Winget (`Mozilla.Firefox`, `Hibbiki.Chromium`).
- **Sincronização:** Total aderência aos 22 Princípios de Engenharia UNIX do Universal Environment.
