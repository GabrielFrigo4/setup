# Universal Setup — Engineering Rules & Constraints

Essas diretrizes são de aplicação obrigatória para qualquer modificação ou extensão neste repositório (`Setup`).

## 1. Modelo Cookbook (Zero-Clone) & Idempotência
- Todas as receitas em `bootstrap/` devem ser autocontidas, atômicas e executáveis diretamente via GitHub (`curl ... | sh`).
- Executar a receita múltiplas vezes DEVE produzir o mesmo estado final sem duplicar linhas, links ou gerar erros de arquivo existente.

## 2. Template Canônico de Receitas (3 Linhas)
Toda receita de provisionamento DEVE utilizar o cabeçalho oficial:
```sh
#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: [Nome do Software / Funcionalidade]
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Nome]: Iniciando configuração..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

# Execução atômica e idempotente

echo "✅ [Nome]: Configurado com sucesso!"
```

## 3. Ordem Canônica de Priorização de Pacotes (Dispatch Universal)
1. Receitas Multi-OS (`FreeBSD` + `Linux`):
   `pkg` (FreeBSD) -> `dnf` (Fedora) -> `apt` (Debian) -> `pacman` (Arch)
2. Receitas Exclusivas de Linux (`bootstrap/linux/`):
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

## 5. Limites de Linhas & Clean Code
- **Piso:** Nenhum script isolado deve ter menos de 16 linhas.
- **Teto:** Nenhum script deve ultrapassar 128 linhas (evitar monólitos).
- Comentários inline narrativos são estritamente proibidos; utilize linhas em branco para separar blocos lógicos.

## 6. Permissões e Segurança
- `chmod 0755` para scripts executáveis.
- `chmod 0644` para arquivos de configuração e Markdown.
- Redirecionamentos para `/dev/null` sempre com aspas: `> "/dev/null"` e `2> "/dev/null"`.

## 7. Checklist de Validação Obrigatório
Antes de concluir qualquer alteração no Setup:
1. `git diff --check` (deve retornar 0 erros).
2. `./.githooks/pre-commit` (deve passar 100%).
3. `python3 scripts/audit/all.py` (deve aprovar 100% dos testes).
