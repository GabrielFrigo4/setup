# 📖 Bootstrap & Catálogo de Receitas (Cookbook)

> Catálogo modular de receitas para provisionamento, instalação de pacotes e configuração do Sistema Operacional (Host, Containers, Servidores e WSL2).

---

## 🎯 A Fronteira: `bootstrap/` vs `software/`

| Camada                                   | Papel Central                        | Tipo de Conteúdo                                                  | Escopo                                                                                                        |
| :--------------------------------------- | :----------------------------------- | :---------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------ |
| **`bootstrap/`** _(esta pasta)_          | **O "COMO" (Provisionamento Ativo)** | Receitas de automação executáveis (`.sh`, `.cmd` e `.ps1`).       | Nível de sistema e máquina (`sudo`/`doas`, `dnf`, `apt`, `pkg`, `winget`, drivers, containers, fontes do SO). |
| **[Profile](https://github.com/GabrielFrigo4/profile)** | **O "O QUÊ" (Estado Declarativo)**   | Arquivos estáticos puros (`.json`, `.toml`, `.yaml`, `.profile`). | Espaço do usuário (`$HOME` / `~/.config`). Zero privilégios de sistema.                                       |

---

## 📂 Organização por Família de SO & Contexto

A estrutura do `bootstrap` é dividida por sistema operacional e categorizada por contextos operacionais rasos:

### 😈 [FreeBSD](freebsd/README.md)

- **[`common/`](freebsd/common/README.md):** Infraestrutura base universal (elevação `doas`, otimizações `/etc/sysctl.conf` e ferramentas CLI essenciais).
- **[`container/`](freebsd/container/README.md):** Subsistema nativo de FreeBSD Jails, automação BastilleBSD e Podman nativo.
- **[`desktop/`](freebsd/desktop/README.md):** Estação de trabalho com interface KDE Plasma 6 Wayland, aceleração de áudio, rede e ports.
- **[`server/`](freebsd/server/README.md):** Máquina virtual servidora FreeBSD sob KVM/QEMU com QEMU Guest Agent e ferramenta de conexão `connect.sh`.

---

### 🐧 [Linux](linux/README.md)

- **[`common/`](linux/common/README.md):** Infraestrutura base universal (Swap agnóstico, `doas` multi-distro, firewall inteligente, Flatpak, Wireshark e Antigravity).
- **[`container/`](linux/container/README.md):** Subsistema de containers de sistema (Incus / LXC) e aplicação (Podman e Docker).
- **[`desktop/`](linux/desktop/README.md):** Distribuições para estações de trabalho gráficas ([Fedora](linux/desktop/fedora/README.md), [Arch Linux](linux/desktop/arch/README.md), [Debian](linux/desktop/debian/README.md)).
- **[`server/`](linux/server/README.md):** Servidores remotos na nuvem (`oracle-frigo`, `oracle-orbs`, Magalu Cloud / Rocky Linux) e ferramenta `connect.sh`.
- **[`wsl/`](linux/wsl/README.md):** Distribuições Linux (Arch Linux e Debian) executando via WSL2.

---

### 🪟 [Windows](windows/README.md)

- **[`native/`](windows/native/README.md):** Ferramentas nativas do Windows (pacotes Winget/Scoop/Choco, suite de engenharia reversa, editores e módulos).
- **[`msys2/`](windows/msys2/README.md):** Subsistema UNIX nativo UCRT64 (7 receitas temáticas de toolchains GCC, Clang e bibliotecas sem virtualização).

---

### 🌐 [Common (Multiplataforma POSIX)](common/README.md)

- Receitas universais em POSIX Shell (`.sh`) compartilhadas entre Linux, FreeBSD, macOS, WSL2 e MSYS2 (fontes, perfis de editores, extensões, linters e vcs).

---

## 📜 O Template Canônico de Receitas (`RECIPE TEMPLATE`)

Para criar ou editar scripts mantendo a consistência do ecossistema, use o cabeçalho minimalista de 3 linhas com a resolução canônica em linha da variável `ELEVATE`:

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

---

## 🔍 Anatomia da Elevação Canônica de Privilégios (One-Liner)

A linha de resolução de privilégios condensa 7 linhas procedurais clássicas (`if/elif/else/fi`) em uma expressão POSIX atômica, segura e livre de poluição de contexto:

```sh
ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"
```

### Como ela funciona passo a passo:

1. **Subshell & Captura Atômica (`$( ... )`):**
   - Executa a validação em um subshell isolado via substituição de comando (*command substitution*).
   - A saída gerada (`doas`, `sudo` ou nada) é capturada e atribuída diretamente a `ELEVATE`. Se nenhum comando for emitido, a variável recebe valor vazio `""`.
   - Nenhuma variável intermediária ou código de retorno vaza para a sessão principal.

2. **Detecção Antecipada de Root (`[ "$(id -u)" -ne 0 ]`):**
   - Verifica se o identificador de usuário efetivo (UID) é diferente de 0.
   - Se o script já estiver executando como `root` (UID 0), a expressão retorna falso (código 1).
   - O operador `&&` entra imediatamente em curto-circuito, pulando todas as etapas subsequentes e deixando `ELEVATE=""` sem desperdício de ciclos de CPU.

3. **Precedência POSIX & Agrupamento de Chaves (`{ ...; }`):**
   - No padrão POSIX Shell, os operadores lógicos `&&` e `||` possuem a mesma precedência e são avaliados estritamente da esquerda para a direita.
   - Um encadeamento ingênuo `cmd1 && echo "doas" || cmd2 && echo "sudo"` falha na armadilha de precedência: se `doas` existir, `echo "doas"` é bem-sucedido (código 0), ignorando o `|| cmd2`, mas executando o posterior `&& echo "sudo"` — gerando `doas\nsudo`.
   - O uso rigoroso dos blocos `{ command -v doas ... && echo "doas" || { command -v sudo ... && echo "sudo"; }; }` garante que o fallback para `sudo` seja avaliado estritamente quando `doas` estiver ausente.

4. **Detecção Portável e Silenciosa (`command -v` com Redirecionamentos Citados):**
   - Em conformidade com o padrão POSIX, utiliza `command -v` em vez do binário externo `which` (não padronizado e ausente em instalações mínimas de FreeBSD e containers).
   - Os redirecionamentos `> "/dev/null" 2>&1` são citados com aspas duplas, silenciando completamente tanto a saída padrão quanto eventuais erros no descritor 2.

5. **Hierarquia e Soberania do Usuário (`doas` > `sudo`):**
   - Honra o **Princípio 18 (Soberania do Usuário)**: se o usuário optou por utilizar `doas` (mais enxuto, seguro e preferido em ambientes BSD/Linux avançados), ele é priorizado.
   - Caso `doas` não esteja presente, faz o fallback gracioso para o clássico `sudo`.
   - Caso o sistema não possua nenhum dos dois ou o usuário execute a receita sem privilégios pré-configurados, `ELEVATE` torna-se `""` e o comando subsequente `${ELEVATE} comando` executa nativamente como usuário comum sem abortar a inicialização.
