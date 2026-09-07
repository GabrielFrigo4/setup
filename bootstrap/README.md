# 📖 Bootstrap & Catálogo de Receitas (Cookbook)

> Catálogo modular de receitas para provisionamento, instalação de pacotes e configuração do Sistema Operacional (Host, Containers, Servidores e WSL2).

---

## 🎯 A Fronteira: `bootstrap/` vs `software/`

| Camada                                   | Papel Central                        | Tipo de Conteúdo                                                  | Escopo                                                                                                        |
| :--------------------------------------- | :----------------------------------- | :---------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------ |
| **`bootstrap/`** _(esta pasta)_          | **O "COMO" (Provisionamento Ativo)** | Receitas de automação executáveis (`.sh`, `.cmd` e `.ps1`).       | Nível de sistema e máquina (`sudo`/`doas`, `dnf`, `apt`, `pkg`, `winget`, drivers, containers, fontes do SO). |
| **[Profile](https://github.com/GabrielFrigo4/Profile)** | **O "O QUÊ" (Estado Declarativo)**   | Arquivos estáticos puros (`.json`, `.toml`, `.yaml`, `.profile`). | Espaço do usuário (`$HOME` / `~/.config`). Zero privilégios de sistema.                                       |

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

Para criar ou editar scripts mantendo a consistência do ecossistema, use o cabeçalho minimalista de 3 linhas:

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
