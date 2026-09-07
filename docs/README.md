# 📚 Documentação Técnica & Arquitetural

> Documentação abrangente de arquitetura, princípios de isolamento, sistemas operacionais suportados e componentes da estação de trabalho.

---

## 🎯 Visão Geral

Esta pasta reúne os manuais arquiteturais e técnicos que sustentam o ecossistema do repositório **Configuration**, organizados por áreas de domínio.

---

## 📜 1. Filosofia e Princípios

- **[ARCHITECTURE.md](ARCHITECTURE.md)** — Visão holística da Tríade de Produtividade, fluxos de integração e fronteiras dos repositórios (`Configuration`, `Shell`, `Vault`).
- **[PHILOSOPHY.md](PHILOSOPHY.md)** — A regra de ouro: _Clean Host_, ZFS e a matriz de modularidade.
- **[../PRINCIPLES.md](../PRINCIPLES.md)** — Os 17 Princípios UNIX (_The Art of UNIX Programming_) e as 12 Regras de Clean Code aplicadas ao repositório.

---

## 🖥️ 2. Sistemas Operacionais & Ambientes Gráficos

- **[LINUX.md](LINUX.md)** — Arquitetura do Linux (Fedora, Arch Linux, Debian, WSL2, XDG Base Directory e containers).
- **[BSD.md](BSD.md)** — Particularidades do FreeBSD (`/usr/local/`, ZFS de primeira classe, bhyve e caminhos POSIX).
- **[WINDOWS.md](WINDOWS.md)** — Ambiente nativo Win32, engenharia reversa, subsistema MSYS2 (UCRT64) e WSL2.
- **[MACOS.md](MACOS.md)** — Compatibilidade POSIX / Darwin e consumo de receitas/dotfiles universais.
- **[GNOME.md](GNOME.md)** — Ambiente gráfico padrão no Fedora Workstation (Wayland, Adwaita escuro e atalhos).
- **[KDE.md](KDE.md)** — Ambiente gráfico padrão no FreeBSD Desktop (KDE Plasma 6 Wayland, Polkit e atalhos).
- **[LINUXLATOR.md](LINUXLATOR.md)** — Camada de compatibilidade binária do Linux no kernel FreeBSD.

---

## 🏗️ 3. Infraestrutura, Isolamento & Hardware

- **[BOOTSTRAP.md](BOOTSTRAP.md)** — Arquitetura do Livro de Receitas (Cookbook) do GitHub e Template Canônico.
- **[CONTAINERS.md](CONTAINERS.md)** — Isolamento de desenvolvimento: Incus e Podman no Linux; Bastille Jails e Podman no FreeBSD.
- **[HYPERVISORS.md](HYPERVISORS.md)** — Virtualização completa Type-1/Type-2 e ZVOLs: KVM (Linux), bhyve (FreeBSD) e Hyper-V (Windows).
- **[EXTERNAL.md](EXTERNAL.md)** — Catálogo de instaladores manuais, softwares portáteis e ferramentas fora de repositórios oficiais.

---

## 🔗 4. A Tríade de Produtividade

O repositório `Configuration` opera em simbiose com dois outros projetos complementares:

- **[SHELL.md](SHELL.md)** — O motor dinâmico do terminal (arquitetura modular: `core`, `context`, `target`, `library`, `theme`).
- **[VAULT.md](VAULT.md)** — O cofre seguro e isolado de credenciais, chaves SSH, senhas Wi-Fi e certificados privados.
