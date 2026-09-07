# 📦 Containers e Isolamento de SO

Conforme ditado pelo documento de [Filosofia](PHILOSOPHY.md), a abordagem primária para ambientes de desenvolvimento no Host é o **isolamento estrito em containers**.

Nosso ecossistema opera sob dois níveis complementares de conteinerização:

1. **Containers Efêmeros / OCI (Podman / Docker):** Para microsserviços, bancos de dados temporários e ferramentas isoladas.
2. **Containers de Sistema (Incus / Bastille Jails):** Para ambientes operacionais completos (com init, persistência e múltiplos serviços simultâneos), comportando-se como máquinas virtuais leves de alta densidade.

---

## ⚡ 1. Containers Efêmeros (Podman First)

No nosso ecossistema, **o Podman é o padrão primário para containers OCI**, substituindo o Docker tradicional:

- **Por que Podman?**
    - **Daemonless:** Não há um processo `dockerd` rodando permanentemente como root em background consumindo recursos do host.
    - **Rootless por Padrão:** Os containers rodam sob o usuário padrão sem exigir privilégios administrativos.
    - **Compatibilidade:** Suporta a especificação OCI (`podman run`, `podman-compose`, `Containerfile` / `Dockerfile`).
    - **Multi-OS:** Alinha-se tanto com o Fedora (onde é cidadão de primeira classe nativo) quanto com o FreeBSD (que possui suporte a Podman).
- **Quando Usar:** Subir um banco de dados PostgreSQL rápido para testes, rodar um Redis ou executar ferramentas pontuais empacotadas do Docker Hub.

---

## 🏛️ 2. Containers de Sistema (Incus & Bastille Jails)

Enquanto o Podman isola processos de aplicação única, os **Containers de Sistema** oferecem um sistema operacional completo rodando nativamente sobre o kernel do host:

### 🐧 Linux: Incus (LXC)

- **Tecnologia Base:** LXC (Namespaces do kernel, Cgroups v2).
- **Gerenciador:** **[Incus](https://linuxcontainers.org/incus/)** (mantido pela comunidade oficial do Linux Containers).
- **Experiência:** Provisiona instâncias completas de Debian, Arch Linux, Alpine ou Fedora em menos de 2 segundos. Ideal para instalar toolchains de desenvolvimento, testar ferramentas de automação como OpenTofu/Terraform e compilar código sem poluir o host.

### 😈 FreeBSD: Bastille & Jails

- **Tecnologia Base:** FreeBSD Jails nativo.
- **Gerenciador:** **[BastilleBSD](https://bastillebsd.org/)**.
- **Experiência:** Isolamento de processos, redes e interfaces virtuais (VNET) com segurança lendária e consumo irrisório de memória.

---

## 🛡️ O Papel Crítico do ZFS nos Containers

Tanto no FreeBSD quanto no Linux, os diretórios base dos containers (Incus e Bastille) devem residir diretamente sobre datasets do **ZFS**:

1. **Snapshots Instantâneos:** Capacidade de congelar o estado exato de um container antes de rodar migrações de banco ou compilações arriscadas.
2. **Clonagem Imediata (Copy-on-Write):** Instanciação de réplicas inteiras de containers sem consumo de disco adicional até que os dados sejam modificados.
3. **Resiliência e Checksums:** Proteção em tempo real contra corrupção silenciosa de dados (_bit rot_).

---

> 💡 **Resumo Prático:**
>
> - Precisa de um banco de dados Postgres para um teste rápido? `podman run --rm -d postgres`
> - Precisa de um ambiente de desenvolvimento completo com compiladores e bibliotecas? Suba um container de sistema no **Incus** (Linux) ou no **Bastille** (FreeBSD).
> - **O Host permanece sempre limpo e intocado.**
