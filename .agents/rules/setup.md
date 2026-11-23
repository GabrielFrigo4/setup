# Universal Setup — Engineering Rules & Constraints

Essas diretrizes são de aplicação obrigatória para qualquer modificação ou extensão neste repositório (`Setup`).

> 🏛️ **Hub Orquestrador:** Este repositório faz parte do [Quarteto de Produtividade](https://github.com/GabrielFrigo4/environment), orquestrado pelo repositório **Environment**. Consulte o `ENVIRONMENT.md` e `PRINCIPLES.md` canônicos na raiz do Environment para a arquitetura completa.

## 1. Modelo Clone Soberano, Clean Host & Idempotência

- O repositório opera sob o modelo **Clone Soberano**: [`bootstrap.sh`](../../bootstrap.sh) clona/atualiza `Setup` em `${SETUP_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/setup}`, aplica permissões `0755` e invoca [`setup.sh`](../../setup.sh) consumindo `core/` (`detect.sh`, `elevate.sh`, `pkg.sh`, `perms.sh`, `ui.sh`).
- O sistema hospedeiro segue o princípio **Clean Host**: receitas portáteis em `freebsd/` e `linux/` instalam apenas base, desktop e virtualização; quirks específicos de máquina física residem isolados em `hosts/` (opt-in) e ferramentas pesadas de desenvolvimento residem no perfil opt-in `dev-host`.
- Executar qualquer receita múltiplas vezes DEVE produzir o mesmo estado final sem duplicar linhas, links ou gerar erros de arquivo existente.

## 2. Template Canônico de Receitas (POSIX Shell)

Toda receita de provisionamento DEVE utilizar o cabeçalho oficial de 64 hífens e bibliotecas `core/`:

```sh
#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: [Nome do Software / Funcionalidade]
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Configurando [Nome]..."

_ui_ok "[Nome] configurado com sucesso!"
```

## 3. Ordem Canônica de Priorização de Pacotes & Paradigma do `common/`

- **O Paradigma do `common/` (Despachante Multi-OS Universal):**
  Qualquer ferramenta multiplataforma DEVE residir em `common/<categoria>/<ferramenta>.sh` consumindo `core/pkg.sh` (`_pkg_update`, `_pkg_install`) ou a cascata unificada na ordem estrita:
  `pkg` (FreeBSD) -> `dnf` (Fedora) -> `apt` (Debian/Ubuntu) -> `pacman` (MSYS2 UCRT64 / Arch) -> `winget.exe` (Windows).
- **Pastas Específicas por Sistema (`linux/`, `freebsd/`, `windows/`, `hosts/`):**
  Reservadas estritamente para particularidades de sistema operacional (`linux/`, `freebsd/`, `windows/`) ou quirks específicos de hardware pessoal (`hosts/`).
- **Receitas Exclusivas de Linux (`linux/`):**
  `dnf` (Fedora) -> `apt` (Debian) -> `pacman` (Arch).
- **Origens Canônicas Antifrágeis no FreeBSD (`pkg`):**
  Para pacotes no FreeBSD, utilize a origem canônica do port (`<categoria>/<nome>`, ex: `devel/py-sysctl`, `devel/uv`) em vez de versões de runtime fixas.

## 4. Preferência Absoluta por Flags Longas Autoexplicativas

- Use sempre flags descritivas:
    - `apt-get install --yes`
    - `dnf install --assumeyes`
    - `pkg install --yes`
    - `pacman -S --needed --noconfirm`
    - `flatpak install --assumeyes`
    - `npm install --global`
    - `usermod --append --groups`
    - `winget.exe install --id ... --accept-package-agreements --accept-source-agreements`

## 5. Limites de Linhas & Arquitetura de Comentários

- **Orçamento de Linhas (Regra 8 - 128):** Piso de 8 linhas e teto recomendado de 128 linhas úteis (limite rígido de 256 linhas).
- **Camada 1 (Header Banner):** Exclusivo para linhas 2 a 4, delimitado por 64 hífens (`# ----------------------------------------------------------------`).
- **Camada 2 (Delimitadores Estruturais de Corpo):** Réguas simétricas de 32 caracteres (`### ================================` ou `### --------------------------------`) com título em MAIÚSCULO contido em 32 colunas e sem parênteses.
- **Camada 3 (Zero Comentários Narrativos):** Não use comentários narrativos ou inline em scripts, templates e blocos de código Markdown.

## 6. Permissões e Segurança

- `chmod 0755` para scripts executáveis, `.githooks/*` e `.scripts/audit/*.py`.
- `chmod 0644` para arquivos de configuração, `.cmd`, `.ps1`, `.reg` e documentação Markdown.
- Redirecionamentos para `/dev/null` sempre com aspas: `> "/dev/null" 2>&1`.
- Finais de linha LF em `.sh`, `.md`, `.py`, `.json`, `.yml`; CRLF preservado em `.cmd`, `.ps1` e `.reg`.

## 7. Matriz de Runtimes e Inits (FreeBSD, Systemd, Devuan/Não-Systemd, OpenBSD)

- **FreeBSD:** Scripts em `/usr/local/etc/rc.d/` com `/etc/rc.subr`, `sysrc`, `vidcontrol` e driver `vt(4)`.
- **Debian / Fedora / Arch (Linux com Systemd):** Drop-ins em `/etc/systemd/system/*.d/`, `systemctl daemon-reload` e `localectl`.
- **Devuan / Linux Não-Systemd:** Regras `udev`/`eudev` em `/etc/udev/rules.d/`, OpenRC `/etc/init.d/`, SysVinit LSB e `console-setup`.
- **OpenBSD:** Validação do subsistema `wscons(4)` e `rasops(9)`.

## 8. Checklist de Validação Obrigatório

Antes de concluir qualquer alteração no Setup:

1. `make format`
2. `make ci` (executa `test` + `audit` com 9/9 módulos aprovados)
3. `git diff --check` (0 erros)
