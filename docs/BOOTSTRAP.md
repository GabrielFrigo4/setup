# 🏗️ Arquitetura do Bootstrap & Clone Soberano

Este documento descreve o modelo operacional de **Clone Soberano**, os módulos de fundação em `core/` e a orquestração em camadas de [`setup.sh`](../setup.sh).

---

## 🎯 Filosofia: Clone Soberano (`bootstrap.sh`)

O **Setup** adota um bootstrap em 1 linha com clone persistente local:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/bootstrap.sh | sh -s -- --profile=base
```

1. **Clonagem & Atualização Determinística:** [`bootstrap.sh`](../bootstrap.sh) garante a presença de `git`, clona ou atualiza o repositório em `${SETUP_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/setup}`, aplica `chmod 0755` via [`core/perms.sh`](../core/perms.sh) e transfere execução para [`setup.sh`](../setup.sh) com todos os módulos `core/` disponíveis offline.
2. **4 Camadas de Orquestração (`setup.sh`):**
    - **`base`:** Clean Host portátil (elevação `nopass`, CLI core, VCS tools, fontes e base portátil do SO).
    - **`desktop`:** Bundles completos de desktop (`fedora-desktop`, `arch-desktop`, `debian-desktop`, `freebsd-desktop`).
    - **`virtualization`:** Containers e hypervisors (`incus`/`podman` no Linux; `jails`/`bastille`/`bhyve`/`podman` no FreeBSD).
    - **`dev-host` & `host` (Opt-In):** Toolchains no host (`--profile=dev-host`) e quirks físicos isolados em `hosts/` (`--profile=host`), além de `server`, `doctor`, `audit` e `test`.

---

## 📐 Template Canônico de Receitas (`core/` + POSIX `sh`)

Toda receita utiliza o cabeçalho oficial de 64 hífens e carrega as bibliotecas `core/`:

```sh
#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: [Nome do Software / Funcionalidade]
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando [Nome]..."

_ui_ok "[Nome] configurado com sucesso!"
```

### 🔍 Módulos em [`core/`](../core/README.md)

- **[`core/detect.sh`](../core/detect.sh):** Exporta `DETECTED_OS`, `DETECTED_DISTRO`, `DETECTED_PKG_MGR` e `DETECTED_CONSOLE_FONT`.
- **[`core/elevate.sh`](../core/elevate.sh):** Resolve `ELEVATE` (`doas > sudo`) com segurança sob `set -eu` quando executado como `root`.
- **[`core/pkg.sh`](../core/pkg.sh):** Expõe `_pkg_update` e `_pkg_install` com flags longas (`--yes`, `--assumeyes`, `--needed --noconfirm`, `winget.exe install --id ... --accept-*`).
- **[`core/perms.sh`](../core/perms.sh):** Auto-cura permissões `0755` em `setup.sh`, `bootstrap.sh`, `core/*.sh`, `hosts/*.sh`, `.githooks/*` e `.scripts/audit/*.py`.
- **[`core/ui.sh`](../core/ui.sh):** Biblioteca semântica `_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info` e `_ui_banner`.

---

## 📂 Organização das Receitas por Camadas

- **`common/` (Despachante Multi-OS Universal):** Ferramentas multiplataforma na cascata `pkg -> dnf -> apt -> pacman -> winget.exe` (`cli/`, `editors/`, `fonts/`, `graphics/`, `iso/download.sh`, `languages/`, `linters/`, `media/`, `office/`, `security/`, `system/`, `wasm/`, `web/`).
- **`hosts/` (Quirks de Hardware Opt-In):** Particularidades físicas isoladas por máquina (`vostro3520-freebsd.sh`).
- **`linux/`, `freebsd/`, `windows/` (Específicos de SO):** Configurações exclusivas por sistema operacional e ambiente nativo/MSYS2.
