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
6. **Orçamento de linhas:** Piso < 8 proibido, aviso <= 16, sweet spot 17-128, aviso 129-255, teto > 256 proibido (salvo Whitelist).
7. **Hermetismo de Produção & Invariante `rm -rf .agents`:** Repositório 100% autônomo. Zero acoplamento de código de produção a `.agents/` ou `skills/` (o sistema opera plenamente mesmo se `.agents/` for deletado).
8. **Bancada de Desenvolvimento vs. Runtimes de Produção:** Setup opera sob demanda via receitas individuais ou bootstrap do sistema hospedeiro. NUNCA faça com que receitas criem dependências ou symlinks que apontem para o diretório de desenvolvimento do Environment (`~/Documents/Environment`).
9. **Modularização Atômica & Idempotência de Receitas:** Receitas devem ser estritamente desacopladas, atômicas e modulares por serviço ou ferramenta, eliminando scripts monolíticos e garantindo conformidade rigorosa POSIX `/bin/sh` sem bashismos residuais.
10. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** O Setup deve funcionar imediatamente após um simples `git clone`. Modos octais no Git Index DEVEM ser rigorosamente `0755` para receitas, executáveis e hooks, e `0644` para configurações e documentação.
11. **Emissão Semântica de UI (`_ui_*`):** Toda saída interativa do Setup DEVE adotar a taxonomia `_ui_*` (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`), proibindo `echo` avulsos com emojis ou texto despadronizado.
12. **Governança de Roadmap (Opção C):** O repositório mantém seu [TODO.md](TODO.md) atualizado com a Matriz de Status e Backlog de Refatoração, sincronizado com o badge no `README.md`.

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
    - **Sequências ANSI:** Substituir octais crípticos (`\033`) e `printf` desnecessário por `[ -t 1 ] && echo -n $'\e...'`.
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir imediatamente `echo` avulsos com emojis ou texto ad-hoc pelas rotinas canônicas `_ui_*`.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando runbooks obsoletos para evitar débito cognitivo, preservando sempre o hermetismo de produção (`rm -rf .agents`).

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura do Quarteto de Produtividade
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 21 Princípios de Engenharia UNIX + Clean Code
- **[TODO.md](TODO.md)**: Planejamento estratégico e matriz de status operacional
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Setup
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais (`universal-setup`, `proactive-guardian`, `deep-investigation`)
