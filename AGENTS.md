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
3. **Ordem de dispatch & Paradigma do `common/`:** A pasta `common/` é a camada canônica de provimento de software cross-platform, atuando como um **Despachante Multi-OS Universal** (`pkg` → `dnf` → `apt` → `pacman` [MSYS2 / Arch] → `winget.exe`). Toda ferramenta ou serviço que possa ser instalado em mais de um sistema operacional DEVE residir em `common/<categoria>/<ferramenta>.sh`. As pastas específicas (`linux/`, `freebsd/`, `windows/`) são estritamente reservadas para o que é inerentemente exclusivo e idiossincrático daquele sistema operacional (ex: dconf/GNOME, regras udev, Jails/Linuxulator, sysctl de kernel BSD, atalhos do Windows Shell). Evite isolar pacotes universais dentro de pastas de SO individuais.
4. **Flags longas:** `--yes`, `--assumeyes`, `--needed`, `--noconfirm`.
5. **Taxonomia Tripartite de Comentários:** O código adota estritamente três categorias: 1. Comentários de Sistema = PERMITIDOS (shebangs, pragmas); 2. Comentários Estruturais de 64/32 colunas = PERMITIDOS (cabeçalhos de 64 `-`, seções de 32 caracteres `### ===`, réguas de 64 `=` em `.gitignore`, sem vazamento); 3. Comentários Explicativos/Narrativos = PROIBIDOS em código, configs E blocos de código dentro de Markdowns.
6. **Orçamento de linhas:** Piso < 8 proibido, aviso <= 16, sweet spot 17-128, aviso 129-255, teto > 256 proibido (salvo Whitelist).
7. **Hermetismo de Produção & Invariante `rm -rf .agents`:** Repositório 100% autônomo. Zero acoplamento de código de produção a `.agents/` ou `skills/` (o sistema opera plenamente mesmo se `.agents/` for deletado).
8. **Bancada de Desenvolvimento vs. Runtimes de Produção:** Setup opera sob demanda via receitas individuais ou bootstrap do sistema hospedeiro. NUNCA faça com que receitas criem dependências ou symlinks que apontem para o diretório de desenvolvimento do Environment (`~/Documents/Environment`).
9. **Ciclo Canônico de Propagação & Banimento de Cópia Manual:** Modificações em receitas ou manifests são desenvolvidas na bancada, validadas via `make test` e `make audit`, e propagadas exclusivamente via controle de versão Git.
10. **Modularização Atômica & Idempotência de Receitas:** Receitas devem ser estritamente desacopladas, atômicas e modulares por serviço ou ferramenta, eliminando scripts monolíticos e garantindo conformidade rigorosa POSIX `/bin/sh` sem bashismos residuais.
11. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** O Setup deve funcionar imediatamente após um simples `git clone`. Modos octais no Git Index DEVEM ser rigorosamente `0755` para receitas, executáveis e hooks, e `0644` para configurações e documentação.
12. **Emissão Semântica de UI (`_ui_*`):** Toda saída interativa do Setup DEVE adotar a taxonomia `_ui_*` (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`), sendo proibido `echo` avulso com emojis ou texto despadronizado.
13. **Governança de Roadmap (TODO.md):** O repositório mantém seu [TODO.md](TODO.md) canônico atualizado com a Matriz de Status e Backlog de Refatoração, sincronizado com o badge no `README.md`.
14. **Refatoração Sem Legado / Soberania Monousuário (Clean-Break / Zero-Cruft Invariant):** O ecossistema é estritamente pessoal, governado e operado por um único desenvolvedor soberano (Gabriel Frigo). Evite manter resíduos de retrocompatibilidade, shims temporários, wrappers obsoletos, seções de compatibilidade legada ou aliases de transição ao renomear variáveis, comandos, funções, diretórios ou arquivos, salvo se expressamente ordenado pelo usuário. Toda refatoração deve ser atômica, direta, definitiva e limpa (_clean break_), expurgando o identificador antigo integralmente da base de código.
15. **Ambiente Híbrido Host/Guest (FreeBSD Workstation + Bhyve Linux Runtime):** Em estações FreeBSD, o agente de IA (`agy`) opera isolado dentro de uma máquina virtual Debian no Bhyve (`192.168.8.2`), conectada via NFSv3 à `/home/gabrielf` do host com paridade de UID/GID 1001. O agente executa comandos em ambiente Linux nativo (kernel 6.12/GNU), porém seus arquivos de trabalho residem fisicamente no ZFS do FreeBSD. Ao despachar comandos no terminal, utilize ferramentas Linux disponíveis no guest ou faça a demarcação correta ao editar scripts específicos de cada sistema operacional.
16. **Simetria de Escopo & Não-Assimetria de Subgrupo na Documentação:** Se um comportamento, protocolo ou invariante pertence a todo um grupo de componentes, documente-o no nível do grupo (documento de arquitetura, README do módulo pai ou especificação geral), evitando a criação de falsas assimetrias. Um sub-membro só deve receber documentação específica se implementar o comportamento de forma mais especializada, detalhada ou otimizada.

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA atua de forma proativa na manutenção e aplicação dos padrões canônicos deste repositório.

Ao identificar linhas ou artefatos fora dos padrões estabelecidos:

1. **Notificar concisamente** o usuário sobre o ajuste realizado.
2. **Corrigir a inconformidade**, aplicando o padrão correspondente:
    - **Taxonomia Tripartite de Comentários:** Eliminar comentários explicativos óbvios em código, configs e blocos de código em Markdowns, preservando exclusivamente comentários de sistema e delimitadores estruturais (64/32 colunas).
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo (ou 64 `=` em `.gitignore`).
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI & Escapes:** Não use octais (`\033`, `\001`) para caracteres ou escapes. Use `[ -t 1 ] && echo -n $'\e...'` ou notação hexadecimal (`\x01`, `\x1b`). Octal é exclusivo para permissões POSIX (`chmod 0755`, `chmod 0644`, `umask`).
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir `echo` avulsos com emojis pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e validação defensiva de pré-requisitos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando ruído obsoleto.
    - **Refatoração Sem Legado:** Expurgar aliases obsoletos, variáveis mortas e shims de compatibilidade em renomeações.
    - **Elevação Antifrágil & Shift Seguro:** Usar o bloco explícito `if [ "$(id -u)" -ne 0 ]` para resolução de `ELEVATE` (evitando término fatal sob `set -e` como root) e proteger todo comando `shift` com validação prévia de parâmetros (`[ "$#" -ge N ] && shift N`).
    - **Simetria de Documentação:** Mover regras ou invariantes universais documentadas erroneamente em sub-membros específicos para o documento de arquitetura do grupo correspondente, eliminando falsas assimetrias.

---

## 🚀 Comandos de Verificação Rápida (Quality Gates)

| Comando            | Finalidade Operacional                                         |
| :----------------- | :------------------------------------------------------------- |
| `make help`        | Exibe o catálogo interativo de comandos disponíveis            |
| `make test`        | Valida sintaxe e shebangs de todas as receitas POSIX `/bin/sh` |
| `make audit`       | Executa a suíte completa de auditoria estática                 |
| `make format`      | Formata receitas, scripts e documentações com Prettier         |
| `make prettier`    | Formata arquivos Markdown com Prettier                         |
| `make fix-banners` | Corrige automaticamente a geometria de réguas e banners        |
| `make doctor`      | Executa diagnóstico de saúde do sistema e pré-requisitos       |
| `make hooks`       | Configura permissão `0755` nos ganchos de `.githooks/`         |
| `make ci`          | Executa a pipeline local completa de validação (`test audit`)  |

---

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura do Quarteto de Produtividade
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 22 Princípios de Engenharia UNIX + Clean Code
- **[TODO.md](TODO.md)**: Planejamento estratégico e matriz de status operacional
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Setup
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais do Setup
