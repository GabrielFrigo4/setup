# Universal Setup — Engineering Rules & Constraints

Essas diretrizes são de aplicação obrigatória para qualquer modificação ou extensão neste repositório (`Setup`).

## 1. Modelo Cookbook (Zero-Clone) & Idempotência

- Todas as receitas devem ser autocontidas, atômicas e executáveis diretamente via GitHub (`curl ... | sh`).
- Executar a receita múltiplas vezes DEVE produzir o mesmo estado final sem duplicar linhas, links ou gerar erros de arquivo existente.

## 2. Template Canônico de Receitas (POSIX Shell)

Toda receita de provisionamento DEVE utilizar o cabeçalho oficial de 64 hífens:

```sh
#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: [Nome do Software / Funcionalidade]
# ----------------------------------------------------------------
set -eu

echo "📦 [Nome]: Iniciando configuração..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

echo "✅ [Nome]: Configurado com sucesso!"
```

## 3. Ordem Canônica de Priorização de Pacotes (Dispatch Universal)

1. Receitas Multi-OS (`FreeBSD` + `Linux`):
   `pkg` (FreeBSD) -> `dnf` (Fedora) -> `apt` (Debian) -> `pacman` (Arch)
2. Receitas Exclusivas de Linux (`linux/`):
   `dnf` (Fedora) -> `apt` (Debian) -> `pacman` (Arch)

## 4. Preferência Absoluta por Flags Longas Autoexplicativas

- Use sempre flags descritivas:
    - `apt install --yes`
    - `dnf install --assumeyes`
    - `pkg install --yes`
    - `pacman -S --needed --noconfirm`
    - `flatpak install --assumeyes`
    - `npm install --global`
    - `usermod --append --groups`

## 5. Limites de Linhas & Arquitetura de Comentários

- **Orçamento de Linhas (Regra 8 - 128):** Piso de 8 linhas e teto de 128 linhas úteis.
- **Camada 1 (Header Banner):** Exclusivo para linhas 2 a 4, delimitado por 64 hífens (`# ----------------------------------------------------------------`).
- **Camada 2 (Delimitadores Estruturais de Corpo):** Réguas simétricas de 32 caracteres (`### ================================` ou `### --------------------------------`). O título DEVE ter no máximo 32 caracteres e JAMAIS vazar além da régua (total de 36 colunas com `### `).
- **Camada 3 (Zero Comentários Narrativos):** Proibição absoluta de comentários narrativos ou inline em scripts, templates e exemplos. Utilize linhas em branco para separar blocos lógicos.

## 6. Padrão Universal de READMEs

- **README Raiz:** Portal institucional com título e emoji, blockquote de missão, badges do Quarteto de Produtividade, sistemas suportados, catálogo de primeiro nível e instruções de auditoria/CI.
- **README de Subpastas:** Catálogo tabular obrigatório (`| Arquivo / Receita | Descrição | Plataforma |`) e bloco de execução limpo sem comentários inline.

## 7. Permissões e Segurança

- `chmod 0755` para scripts executáveis.
- `chmod 0644` para arquivos de configuração e Markdown.
- Redirecionamentos para `/dev/null` sempre com aspas: `> "/dev/null"` e `2> "/dev/null"`.

## 8. Checklist de Validação Obrigatório

Antes de concluir qualquer alteração no Setup:

1. `git diff --check` (deve retornar 0 erros).
2. `./.githooks/pre-commit` (deve passar 100%).
3. `python3 scripts/audit/all.py` (deve aprovar 100% dos testes).
