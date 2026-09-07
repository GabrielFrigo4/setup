# 📦 Universal Setup Environment

> Repositório público de provisionamento de sistema operacional, receitas atômicas de infraestrutura, drivers de hardware, containers e estações de trabalho limpas (*Clean Host*). Componente de sistema do **Quarteto de Produtividade**.

---

### 🏛️ O Quarteto de Produtividade

[![Setup](https://img.shields.io/badge/📦_Setup-Sistema_%26_Cookbook-blue)](https://github.com/GabrielFrigo4/setup)
[![Shell](https://img.shields.io/badge/🐚_Shell-Terminal_Runtime-purple)](https://github.com/GabrielFrigo4/shell)
[![Vault](https://img.shields.io/badge/🔐_Vault-Cofre_Privado-red)](https://github.com/GabrielFrigo4/vault)
[![Profile](https://img.shields.io/badge/🎨_Profile-Dotfiles_%26_IA-green)](https://github.com/GabrielFrigo4/profile)

> 📖 **Arquitetura Unificada do Ecossistema:** Conheça a matriz completa de responsabilidades, ciclo de boot e segregação de privilégios em [ENVIRONMENT.md](ENVIRONMENT.md).
> 📜 **Princípios de Engenharia & Infraestrutura:** Conheça os 18 princípios e as 14 regras de Clean Code em [PRINCIPLES.md](PRINCIPLES.md).

---

### 🖥️ Sistemas Operacionais Suportados

![Linux](https://img.shields.io/badge/🐧_Linux_%28Fedora_/_Arch_/_Debian%29-Supported-blue)
![FreeBSD](https://img.shields.io/badge/😈_FreeBSD-Supported-red)
![Windows](https://img.shields.io/badge/🪟_Windows_%28Native_/_MSYS2%29-Supported-purple)

### 🎨 Interfaces Gráficas Nativas (Host)

![GNOME](https://img.shields.io/badge/🔵_GNOME_%28Fedora%29-Wayland-blue)
![KDE Plasma](https://img.shields.io/badge/🟢_KDE_Plasma_%28FreeBSD%29-Wayland-green)

---

## 🧠 Filosofia: O "Clean Host" e o Modelo Cookbook (Zero-Clone)

O **Setup** provê a fundação do sistema operacional com privilégios administrativos (`root` / `sudo` / `ELEVATE`):

1. **"Clean Host" (Isolamento Extremo):** O sistema nativo (o *host*) permanece o mais puro possível. Ele provê apenas a interface gráfica Wayland, drivers de hardware, utilitários essenciais e a camada de virtualização/containers. Bancos de dados e runtimes de projetos vivem em Containers (Incus, Podman, Docker) ou Jails (FreeBSD).
2. **Zero Dependência de Clone:** Concebido como um **Catálogo de Receitas Modular (Cookbook)**. Você não precisa clonar este repositório para utilizá-lo. Navegue pelos arquivos diretamente na interface web do GitHub ou execute receitas pontuais via terminal.
3. **Idempotência Rigorosa:** Cada receita pode ser executada uma, duas ou dez vezes seguidas produzindo o mesmo estado estável.

---

## 📂 Estrutura do Projeto

- **[`bootstrap/`](bootstrap/README.md)** — **Catálogo Modular de Receitas de Sistema (O "COMO"):**
  - **`freebsd/`** — Infraestrutura base (`common/`), Containers (Jails & Bastille), Workstation Desktop (KDE Plasma) e Servidores.
  - **`linux/`** — Infraestrutura base (`common/`), Containers (Incus & Podman), Workstations Desktop (Fedora, Arch, Debian), Servidores Cloud e WSL2 (`wsl/`).
  - **`windows/`** — Ferramentas nativas (`native/`) e subsistema MSYS2 (`msys2/` UCRT64).
  - **`common/`** — Receitas universais compartilhadas entre Linux, FreeBSD e Windows (fontes, linters, editores, vcs).
- **[`scripts/`](scripts/README.md)** — Utilitários de compilação local (`build/`), conversão de arquivos (`convert/`), automações de registro do Windows (`windows/`) e auditoria contínua (`audit/`).
- **[`docs/`](docs/README.md)** — Documentação técnica da infraestrutura do host (`BOOTSTRAP.md`, `CONTAINERS.md`, `HYPERVISORS.md`, `BSD.md`, `LINUX.md`, `WINDOWS.md`).

---

## 🚀 Como Usar via GitHub (Zero-Clone)

```sh
# Exemplo 1: Executar receita do Fedora Desktop diretamente via curl
curl -fsSL "https://raw.githubusercontent.com/GabrielFrigo4/setup/main/bootstrap/linux/desktop/fedora/desktop/gnome.sh" | sh

# Exemplo 2: Executar receita de fontes universais
curl -fsSL "https://raw.githubusercontent.com/GabrielFrigo4/setup/main/bootstrap/common/fonts/fonts.sh" | sh

# Exemplo 3: Executar o orquestrador interativo local (se clonado)
./setup.sh
```

---

## 🔗 Integração com o Quarteto de Produtividade

Após provisionar a máquina hospedeira com o **Setup**:
1. Instale o motor interativo de linha de comando com o **[Shell](https://github.com/GabrielFrigo4/shell)**.
2. Clone seu cofre de credenciais e chaves criptográficas com o **[Vault](https://github.com/GabrielFrigo4/vault)**.
3. Clone e sincronize seus dotfiles e assistentes de IA com o **[Profile](https://github.com/GabrielFrigo4/profile)**.
