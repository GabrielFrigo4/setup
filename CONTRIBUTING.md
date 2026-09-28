# 🤝 Guia de Contribuição — Universal Setup

> Diretrizes de desenvolvimento, setup inicial da bancada, receitas de infraestrutura e quality gates para o **Universal Setup**.

---

## 🚀 Setup Inicial da Bancada (Primeiros Passos)

Para clonar e configurar o repositório localmente com todos os ganchos e quality gates ativados:

```sh
# 1. Clonar o repositório
git clone "https://github.com/GabrielFrigo4/setup.git" "${HOME}/Documents/Setup"
cd "${HOME}/Documents/Setup"

# 2. Configurar ganchos Git e permissões canônicas
make hooks

# 3. Validar a sintaxe POSIX de todas as receitas
make test

# 4. Executar a suíte de auditoria estática e arquitetura
make audit
```

> [!IMPORTANT]
> O comando `make hooks` configura `core.hooksPath -> .githooks` e aplica permissões canônicas `0755` aos ganchos de pre-commit e commit-msg. Execute-o sempre após um novo clone.

---

## 🛡️ Invariantes de Engenharia no Setup

1. **Idempotência Absoluta:**
    - Toda receita DEVE ser reexecutável repetidamente sem gerar efeitos colaterais, duplicação de linhas ou erros de "arquivo já existe".

2. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Invariant):**
    - Receitas de provisionamento e scripts de auditoria devem ter modo octal canônico `100755` no Git Index.
    - Arquivos estáticos (documentações, templates `.md`, configurações) devem ter modo `100644`.
    - Se cometer um erro de modo no Git Index, corrija com:
        ```sh
        git update-index --chmod=+x caminho/receita.sh
        git update-index --chmod=-x caminho/arquivo.md
        ```

3. **Conformidade Estrita com POSIX `/bin/sh`:**
    - Shebang obrigatório: `#!/usr/bin/env sh`.
    - Proibidos bashismos (`[[ ]]`, arrays, `&>`, `source`).
    - Redirecionamentos de segurança com aspas obrigatórias: `> "/dev/null" 2>&1`.

4. **Orçamento de Linhas (Regra 8 - 16 - 128 - 256):**
    - Mínimo de 8 linhas úteis (erro fatal para scripts < 8 linhas).
    - Teto máximo de 256 linhas úteis (monólitos proibidos).
    - Faixa ideal: 17 a 128 linhas.

5. **Padrão Canônico de Banners:**
    - Topo: exatamente 64 hífens (`# ----------------------------------------------------------------`).
    - Seções internas: exatamente 32 caracteres (`### ================================` ou `### --------------------------------`).

---

## 🪝 Quality Gates & Validação Local

O repositório possui uma bateria completa de testes e auditorias:

```sh
make test     # Valida sintaxe POSIX (sh -n)
make audit    # Executa a suíte Python: monoliths, nanos, syntax, banners, links, formats
make doctor   # Diagnóstico de integridade do host
make ci       # Executa bateria completa de CI local
```

Ganchos Git em `.githooks/`:

- **`pre-commit`:** Verifica whitespace, modos octais no Git Index (0755 vs 0644), sintaxe de shell, redirecionamentos e Prettier.
- **`commit-msg`:** Valida formato semântico da mensagem de commit.

---

## 📝 Convenção de Commits Semânticos

As mensagens de commit devem seguir o formato:

```text
<tipo>(<escopo>): <descrição objetiva>
```

Tipos permitidos: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `ci`, `chore`.

---

## 📖 Referências Canônicas

- [README.md](README.md) — Visão geral e catálogo de perfis
- [PRINCIPLES.md](PRINCIPLES.md) — Princípios de Engenharia e Clean Code
- [AGENTS.md](AGENTS.md) — Briefing para agentes autônomos de IA
- [TODO.md](TODO.md) — Roadmap operacional do Setup
