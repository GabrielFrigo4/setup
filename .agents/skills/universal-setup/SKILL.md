---
name: universal-setup
description: >-
    Comprehensive guide and operational runbook for extending, refactoring, and auditing the Universal Setup repository.
    Use when creating new system recipes, managing package managers (pkg, dnf, apt, pacman, winget),
    isolating hardware quirks in hosts/, configuring containers (Incus, Podman, Jails, Bhyve), and enforcing Clean Host standards.
---

# Universal Setup — Development & Infrastructure Runbook

Este guia orienta a evolução e auditoria do repositório **Setup** sob o modelo **Clone Soberano (`bootstrap.sh`) + Clean Host + Separação `hosts/`**.

---

## 1. Mapeamento de Camadas

| Camada                        | Diretório  | Papel & Responsabilidade                                                 | Exemplos                                                |
| :---------------------------- | :--------- | :----------------------------------------------------------------------- | :------------------------------------------------------ |
| **Núcleo do Orquestrador**    | `core/`    | Bibliotecas internas (`detect`, `elevate`, `pkg`, `perms`, `ui`)         | `core/pkg.sh`, `core/ui.sh`                             |
| **Hardware Opt-In**           | `hosts/`   | Quirks físicos isolados por máquina (GPU, NIC, Wi-Fi, áudio, ACPI)       | `hosts/vostro3520-freebsd.sh`                           |
| **Multiplataforma**           | `common/`  | Receitas universais em cascata `pkg -> dnf -> apt -> pacman -> winget`   | `common/cli/core.sh`, `common/iso/download.sh`          |
| **Linux Base & Server**       | `linux/`   | Receitas portáteis para Fedora, Arch, Debian, WSL2, Ubuntu e containers  | `linux/desktop/fedora/desktop/gnome.sh`, `podman.sh`    |
| **FreeBSD Base & Hypervisor** | `freebsd/` | FreeBSD portátil, KDE Plasma 6 Wayland, Jails, Bastille, Podman e Bhyve  | `freebsd/desktop/system/system.sh`, `bhyve.sh`          |
| **Windows & MSYS2**           | `windows/` | `winget.json`, `scoop.cmd`, `setup.ps1`, registro/Hyper-V e MSYS2 UCRT64 | `windows/native/security/ghidra.cmd`, `msys2/system.sh` |

---

## 2. Invariantes Arquiteturais

1. **Clone Soberano (`bootstrap.sh`):** Bootstrap em `~/.local/share/setup` (`$SETUP_DIR`) com auto-cura de permissões (`core/perms.sh`) e despacho via `setup.sh`.
2. **Idempotência & Clean-Break:** Receitas reexecutáveis sem duplicações ou shims legados; hardware específico nunca vaza para `freebsd/` ou `linux/`.
3. **Orçamento & Estilo POSIX:** Shebang `#!/usr/bin/env sh`, `set -eu`, UI semântica via `core/ui.sh` (`_ui_step`/`_ui_ok`), zero comentários narrativos, `8..128` linhas (teto `256`).
4. **Escapes ANSI & Quoting:** Sempre use `[ -t 1 ] && echo -n $'\e...'` ou `\x1b` (nunca `\033`/`\001` octais), `"${VAR}"` e redirecionamento `> "/dev/null" 2>&1`.
5. **Consoles Virtuais TTY (Spleen & Cursor Estático):**
    - Escalonamento bitmap Spleen: `spleen-8x16` (`<1080p`), `spleen-12x24` (`1080p`), `spleen-16x32` (`1440p`), `spleen-32x64` (`>=2160p`).
    - Linux `fbcon`: `vt.cur_default=0xee10` (`60944`), `/etc/issue` com `\x1b%G\x1b[?16;238;0c`, paleta DAC `\x1b]P0`..`\x1b]PF` e init neutro (`systemd`, `udev`, `OpenRC`, `SysVinit`).
    - FreeBSD: serviço `vt_autofont` em `/usr/local/etc/rc.d/` e `kern.vt.enable_bell=0`.

---

## 3. Quality Gates Obrigatórios

```sh
make format
make ci
git diff --check
```
