---
name: universal-setup
description: >-
    Comprehensive guide and operational runbook for extending, refactoring, and auditing the Universal Setup repository.
    Use when creating new system recipes, managing package managers (dnf, apt, pkg, pacman, winget),
    configuring containers (Incus, Podman, Jails), hypervisors, and enforcing Clean Host standards.
---

# Universal Setup — Development & Infrastructure Runbook

Este guia detalha o fluxo operacional para estender, refatorar e auditar o repositório **Universal Setup Environment** (`Setup`), garantindo aderência rigorosa aos 22 Princípios de Engenharia UNIX + Clean Code.

---

## 1. Mapeamento de Camadas (Onde colocar cada receita)

Antes de escrever qualquer código, posicione a receita no diretório correto:

| Camada                    | Diretório  | Papel & Responsabilidade                                                  | Exemplos                                          |
| :------------------------ | :--------- | :------------------------------------------------------------------------ | :------------------------------------------------ |
| **Multiplataforma**       | `common/`  | Receitas universais compartilhadas entre Linux, FreeBSD, macOS e Windows. | Fontes, linters, extensões                        |
| **Linux Base & Server**   | `linux/`   | Receitas para Fedora, Arch, Debian, WSL2, servidores e containers.        | `fedora/desktop/gnome.sh`, `container/podman.sh`  |
| **FreeBSD Base & Server** | `freebsd/` | Receitas para FreeBSD nativo, KDE Plasma 6 Wayland, Jails e BastilleBSD.  | `desktop/system/system.sh`, `container/jails.sh`  |
| **Windows & MSYS2**       | `windows/` | Ferramentas nativas do Windows (Winget, registry) e toolchains MSYS2.     | `native/reverse-engineering.cmd`, `msys2/base.sh` |

---

## 2. Invariantes Arquiteturais Inegociáveis

1. **Idempotência Absoluta:**
    - Toda receita DEVE poder ser reexecutada sem efeitos colaterais destrutivos, sem falhas de "arquivo já existe" e sem duplicar entradas em arquivos de configuração.
2. **Template Canônico de Receitas:**
    - Shebang `#!/usr/bin/env sh`, cabeçalho compacto de 3 linhas e modo defensivo `set -eu`.
3. **Dispatch Leve vs Isolamento por Distro:**
    - Use dispatch universal (`if command -v pkg ...`) em receitas de infraestrutura comum.
    - Isole receitas gráficas complexas em subpastas de distros (`fedora/`, `arch/`, `debian/`).
4. **Flags Longas e Descritivas:**
    - `--assumeyes`, `--yes`, `--needed`, `--noconfirm`, `--global`.
5. **Zero Comentários Narrativos:**
    - O código deve ser autoexplicativo. Separe blocos lógicos com linhas em branco.
6. **Limites de Tamanho de Script:**
    - Piso: >= 8 linhas.
    - Teto: <= 128 linhas.

---

## 3. Consoles Virtuais TTY (Fontes de 512 Glifos & Cursor Estático)

Em estações de trabalho e servidores, o provisionamento de consoles virtuais (TTY) deve assegurar legibilidade em telas de alta densidade e estabilidade visual:

1. **Seleção de Fonte Canônica:**
    - Fonte **Spleen 12x24** (`spleen-12x24`): equilíbrio métrico ideal entre legibilidade e densidade de colunas.
    - Configurada via `/etc/vconsole.conf` (`FONT="spleen-12x24"`) no Linux e `allscreens_flags="-f spleen-12x24"` no FreeBSD.
2. **Invariante de 512 Glifos & Deslocamento de Atributos:**
    - Fontes Unicode como Spleen contêm 512 glifos, ativando `vc_hi_font_mask = 0x0100` no kernel Linux (`vt.c`).
    - O bit 8 é apropriado pelo índice do caractere, deslocando o foreground para os bits 9–11 e o background para os bits 13–15.
3. **Cursor Estático sem Corrupção de Cor (Prevenção de Ciano/Verde):**
    - Flags automáticas do kernel (`CUR_ALWAYS_BG` / `CUR_INVERT_FG_BG`) utilizam máscaras rígidas de 256 glifos (`0x7000`), corrompendo o background para ciano.
    - O padrão canônico adota `CUR_SW` exclusivo (16) com máscara XOR calibrada para 512 glifos (`p2 = 238` / `0xee`), invertendo o fundo para branco sólido (`7`) e o texto para preto (`0`) sem tinturas.
    - **Kernel Boot:** `vt.cur_default=0xee10` (decimal `60944`) no GRUB e `grubby`.
    - **Persistência sysfs:** `/etc/tmpfiles.d/console-cursor.conf` (`w /sys/module/vt/parameters/cur_default ... 60944`).
    - **Login Prompt:** `/etc/issue` configurado com `\033%G\033[?16;238;0c`.
    - **FreeBSD:** `allscreens_flags="-f spleen-12x24"`.

---

## 4. Checklist de Validação Obrigatório

```sh
git diff --check

python3 .scripts/audit/all.py

./.githooks/pre-commit
```
