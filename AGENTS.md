# 📦 Universal Setup — AI Agent Briefing

> Repositório público de provisionamento de sistema operacional, receitas atômicas de infraestrutura, drivers de hardware, containers e estações de trabalho limpas (_Clean Host_). Componente de sistema do **Quarteto de Produtividade**.

---

## 🧭 Identidade e Papel

O **Setup** é o pilar de **provisionamento de sistema operacional** do ecossistema. Opera com **privilégios administrativos** (`root` / `sudo` / `doas`) e é responsável por:

- Instalar pacotes de sistema, drivers de hardware e kernels
- Configurar ambientes gráficos Wayland (GNOME / KDE Plasma)
- Provisionar containers (Incus, Podman, Jails) e hipervisores
- Funcionar como **Cookbook Zero-Clone** — receitas executáveis diretamente via GitHub

---

## ⚠️ Regras Críticas para Agentes de IA

1. **Idempotência absoluta:** Toda receita DEVE ser reexecutável sem efeitos colaterais.
2. **Template canônico:** Shebang `#!/usr/bin/env sh`, header de 64 hífens, `set -eu`.
3. **Ordem de dispatch:** `pkg` → `dnf` → `apt` → `pacman`.
4. **Flags longas:** `--yes`, `--assumeyes`, `--needed`, `--noconfirm`.
5. **Zero comentários narrativos:** Código autoexplicativo, blocos separados por linhas em branco.
6. **Limites de script:** Piso de 8, teto de 128 linhas úteis.

---

## 📖 Referências Obrigatórias

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura do Quarteto de Produtividade
- **[PRINCIPLES.md](PRINCIPLES.md)**: 18 Princípios de Engenharia + Clean Code
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Setup
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais (`universal-setup`, `proactive-guardian`, `deep-investigation`)
