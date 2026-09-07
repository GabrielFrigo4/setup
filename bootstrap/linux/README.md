# 🐧 Linux — Família de Distribuições & Ambientes

> Diretório raiz de provisionamento para distribuições Linux de desktop, servidores, containers e WSL2.

---

## 🎯 Finalidade

Reúne o ferramental de provisionamento para a família Linux, organizado por contexto operacional:

- **`common/`**: Infraestrutura base universal (Swap agnóstico, doas multi-distro, firewall inteligente, Flatpak, Wireshark e Antigravity).
- **`container/`**: Subsistema de containers de sistema (Incus / LXC) e aplicação (Podman e Docker).
- **`desktop/`**: Distribuições de estação de trabalho gráfica (Fedora, Arch Linux, Debian).
- **`server/`**: Instâncias de servidores remotos na nuvem (`oracle-frigo`, `oracle-orbs`, Magalu Cloud / Rocky Linux).
- **`wsl/`**: Distribuições Linux executando sob o subsistema Windows Subsystem for Linux (WSL2).

---

## 📂 Contextos Operacionais

| Contexto                                | Tipo                     | Descrição                                                                          |
| :-------------------------------------- | :----------------------- | :--------------------------------------------------------------------------------- |
| **[`common/`](common/README.md)**       | Infraestrutura Base      | Swap agnóstico, elevação `doas` (0440), firewall, Flatpak, Wireshark e Antigravity |
| **[`container/`](container/README.md)** | Subsistema de Containers | Containers de sistema (Incus/LXC) e containers de aplicação (Podman/Docker)        |
| **[`desktop/`](desktop/README.md)**     | Estações de Trabalho     | Catálogo por distribuição (Fedora, Arch Linux, Debian)                             |
| **[`server/`](server/README.md)**       | Servidores em Nuvem      | Setups de aplicações (Caddy, Resume, Game, Catalogo) e conexão unificada SSH/SCP   |
| **[`wsl/`](wsl/README.md)**             | Subsistema WSL2          | Setups atômicos de Arch Linux e Debian no WSL2                                     |

---

## 🚀 Como Navegar

Para acessar as receitas da sua estação de trabalho principal, navegue até [`desktop/`](desktop/README.md).
