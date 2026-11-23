# 📚 Documentação Técnica & Arquitetural

> Documentação abrangente de arquitetura, princípios de isolamento, sistemas operacionais suportados e componentes da estação de trabalho.

---

## 🎯 Visão Geral

Esta pasta reúne os manuais arquiteturais e técnicos que sustentam o ecossistema do repositório **Setup**, organizados por áreas de domínio.

---

## 📜 1. Filosofia e Princípios

- **[ARCHITECTURE.md](ARCHITECTURE.md)** — Visão holística do Quarteto de Produtividade, fluxos de integração e fronteiras dos repositórios (`Setup`, `Shell`, `Vault`, `Profile`).
- **[PHILOSOPHY.md](PHILOSOPHY.md)** — A regra de ouro: _Clean Host_, ZFS, separação `hosts/` e modularidade soberana.
- **[../PRINCIPLES.md](../PRINCIPLES.md)** — Os 22 Princípios de Engenharia UNIX + Clean Code aplicados ao repositório.

---

## 🖥️ 2. Sistemas Operacionais & Ambientes Gráficos

- **[LINUX.md](LINUX.md)** — Arquitetura do Linux (Fedora, Arch Linux, Debian, WSL2, servidor Ubuntu, XDG Base Directory e containers).
- **[BSD.md](BSD.md)** — Particularidades do FreeBSD (`/usr/local/`, ZFS, Bhyve, Jails, `hosts/` e caminhos POSIX).
- **[WINDOWS.md](WINDOWS.md)** — Ambiente nativo Win32 (`winget.json`, registro, Hyper-V), engenharia reversa, MSYS2 (UCRT64) e WSL2.
- **[MACOS.md](MACOS.md)** — Compatibilidade POSIX / Darwin e consumo das receitas multiplataforma em `common/`.
- **[GNOME.md](GNOME.md)** — Ambiente gráfico padrão no Fedora Workstation (Wayland, Adwaita adaptativo e atalhos).
- **[KDE.md](KDE.md)** — Ambiente gráfico padrão no FreeBSD Desktop (KDE Plasma 6 Wayland, Polkit e atalhos).
- **[COMPAT.md](COMPAT.md)** — Camada de compatibilidade binária do Linux no kernel FreeBSD (`/compat/linux`).

---

## 🏗️ 3. Infraestrutura, Isolamento & Hardware

- **[BOOTSTRAP.md](BOOTSTRAP.md)** — Arquitetura do modelo **Clone Soberano (`bootstrap.sh`)**, módulos `core/` e perfis em `setup.sh`.
- **[CONTAINERS.md](CONTAINERS.md)** — Isolamento de desenvolvimento: Incus e Podman no Linux; Bastille Jails e Podman no FreeBSD.
- **[HYPERVISORS.md](HYPERVISORS.md)** — Virtualização completa Type-1/Type-2 e ZVOLs: KVM (Linux), bhyve (FreeBSD) e Hyper-V (Windows).
- **[EXTERNAL.md](EXTERNAL.md)** — Catálogo de instaladores manuais, softwares portáteis e ferramentas fora de repositórios oficiais.
- **[AI.md](AI.md)** — Inteligência Artificial Local: Ollama, llama.cpp, stack Vulkan e integração com editores.

---

## 🔗 4. Ecossistema Integrado

O repositório **Setup** opera em simbiose com os demais integrantes do **Quarteto de Produtividade**:

- **[SHELL.md](SHELL.md)** — O motor dinâmico do terminal (arquitetura modular: `core`, `context`, `target`, `library`, `theme`).
- **[VAULT.md](VAULT.md)** — O cofre privado e isolado de credenciais, chaves SSH, senhas Wi-Fi e certificados em `~/.local/share/vault`.
