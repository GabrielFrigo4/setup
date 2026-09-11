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

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA **DEVE SER ATIVAMENTE PROATIVO** na manutenção e aplicação dos padrões canônicos deste repositório.

Se durante a execução de qualquer tarefa (seja criação de novas features, correções pontuais, refatorações ou investigação) o agente identificar qualquer linha de código, script, Makefile ou documentação fora dos padrões estabelecidos, **NÃO DEVE HESITAR NEM IGNORAR**:

1. **Notificar concisamente** o usuário sobre a divergência encontrada.
2. **Corrigir imediatamente a inconformidade**, aplicando o padrão canônico correspondente:
    - **Comentários Narrativos:** Eliminar imediatamente comentários óbvios que apenas narram código executável.
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI:** Substituir octais crípticos (``) e `printf` desnecessário por `[ -t 1 ] && echo -n $'\e...'`.
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).

## 📖 Referências Obrigatórias

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura do Quarteto de Produtividade
- **[PRINCIPLES.md](PRINCIPLES.md)**: 18 Princípios de Engenharia + Clean Code
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Setup
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais (`universal-setup`, `proactive-guardian`, `deep-investigation`)
