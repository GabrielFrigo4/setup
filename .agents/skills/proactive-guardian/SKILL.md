---
name: proactive-guardian
description: >-
  Proactive code health guardian and autonomous quality enforcement for Universal Setup.
  Use to continuously audit recipes against the 18 Principles, Clean Code rules,
  dispatch order, long flags, script size limits, and actively suggest or apply fixes.
---

# Proactive Guardian — Autonomous Infrastructure Quality Enforcement

Esta skill define as diretrizes operacionais para atuação **proativa** de qualidade no repositório **Universal Setup Environment** (`Setup`).

O agente nunca deve agir de forma passiva diante de violações de idempotência, flags curtas crípticas, falta de modo defensivo `set -eu` ou scripts monolíticos. Se um desvio for detectado, o agente deve assumir a responsabilidade de auditar, propor e corrigir imediatamente.

---

## 1. Filosofia de Ação Proativa

1. **Ação Direta no Escopo de Receitas:**
   - Se uma receita estiver sem `set -eu`, sem quoting em `> "/dev/null"` ou usando flags curtas como `-y`, **corrija imediatamente para flags longas e formato canônico**.
   - Se uma receita ultrapassar 128 linhas, proponha refatoração modular quebrando em etapas coesas.
2. **Preservação de READMEs de Subpastas:**
   - Toda nova pasta criada deve possuir um `README.md` seguindo o template oficial GitHub-first com catálogo de arquivos e instruções de execução.

---

## 2. Checklist de Auditoria Proativa Contínua

- [ ] **Shebang Canônico:** `#!/usr/bin/env sh` em todas as receitas de shell.
- [ ] **Modo Defensivo:** `set -eu` ativo no início de toda receita.
- [ ] **Elevação Limpa:** Uso de `${ELEVATE}` (`doas > sudo`).
- [ ] **Ordem de Dispatch:** `pkg` -> `dnf` -> `apt` -> `pacman`.
- [ ] **Flags Longas:** `--yes`, `--assumeyes`, `--needed`, `--noconfirm`.
- [ ] **Quoting:** `> "/dev/null"` e `2> "/dev/null"`.
- [ ] **Sem Comentários Narrativos:** Blocos lógicos separados por linhas em branco.
- [ ] **Tamanho Controlado:** Entre 16 e 128 linhas.

---

## 3. Fluxo de Entrega com Qualidade

Antes de finalizar qualquer modificação:
1. `git diff --check`
2. `python3 scripts/audit/all.py`
3. `./.githooks/pre-commit`
