---
name: universal-setup
description: >-
  Comprehensive guide and operational runbook for extending, refactoring, and auditing the Universal Setup repository.
  Use when creating new system recipes, managing package managers (dnf, apt, pkg, pacman, winget),
  configuring containers (Incus, Podman, Jails), hypervisors, and enforcing Clean Host standards.
---

# Universal Setup — Development & Infrastructure Runbook

Este guia detalha o fluxo operacional para estender, refatorar e auditar o repositório **Universal Setup Environment** (`Setup`), garantindo aderência rigorosa aos 18 Princípios de Engenharia e às 14 regras de Clean Code de infraestrutura.

---

## 1. Mapeamento de Camadas (Onde colocar cada receita)

Antes de escrever qualquer código, posicione a receita no diretório correto:

| Camada | Diretório | Papel & Responsabilidade | Exemplos |
| :--- | :--- | :--- | :--- |
| **Multiplataforma** | `bootstrap/common/` | Receitas universais compartilhadas entre Linux, FreeBSD, macOS e Windows. | Fontes, linters, extensões |
| **Linux Base & Server** | `bootstrap/linux/` | Receitas para Fedora, Arch, Debian, WSL2, servidores e containers. | `fedora/desktop/gnome.sh`, `container/podman.sh` |
| **FreeBSD Base & Server** | `bootstrap/freebsd/` | Receitas para FreeBSD nativo, KDE Plasma 6 Wayland, Jails e BastilleBSD. | `desktop/system/system.sh`, `container/jails.sh` |
| **Windows & MSYS2** | `bootstrap/windows/` | Ferramentas nativas do Windows (Winget, registry) e toolchains MSYS2. | `native/reverse-engineering.cmd`, `msys2/base.sh` |

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

## 3. Checklist de Validação Obrigatório

```sh
# 1. Verificar espaços e quebras de linha
git diff --check

# 2. Executar suíte completa de auditoria
python3 scripts/audit/all.py

# 3. Executar o pre-commit hook oficial
./.githooks/pre-commit
```
