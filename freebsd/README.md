# 😈 FreeBSD — Catálogo de Receitas

> Diretório raiz de provisionamento portátil para o sistema operacional FreeBSD, organizado por contexto operacional.

---

## 🎯 Finalidade

Reúne o ferramental de provisionamento portátil para FreeBSD seguindo a especificação POSIX e o `sh` nativo, dividido por contexto (com quirks de hardware pessoal isolados em [`../hosts/`](../hosts/README.md)):

- **`common/`**: Infraestrutura base universal (elevação `doas`, otimizações portáteis de kernel e ferramentas CLI essenciais).
- **`desktop/`**: Estação de trabalho portátil com KDE Plasma 6 Wayland, console `vt_autofont`, `sndiod`, dispositivos e ports.
- **`server/`**: Máquina virtual servidora FreeBSD sob KVM/QEMU com QEMU Guest Agent.
- **`container/`**: Subsistema nativo de FreeBSD Jails, BastilleBSD, hypervisor Bhyve e Podman nativo.

---

## 📂 Contextos Operacionais

| Contexto                                | Tipo                    | Descrição                                                                             |
| :-------------------------------------- | :---------------------- | :------------------------------------------------------------------------------------ |
| **[`common/`](common/README.md)**       | Infraestrutura Base     | Elevação `doas` (`0440`), parâmetros portáteis de kernel e ferramentas CLI essenciais |
| **[`desktop/`](desktop/README.md)**     | Estação de Trabalho     | Ambiente KDE Plasma 6, console Spleen, dispositivos, Wi-Fi e ports                    |
| **[`server/`](server/README.md)**       | Servidor em VM          | Guest Agent para KVM e elevação persistente                                           |
| **[`container/`](container/README.md)** | Containers & Hypervisor | Jails nativas, BastilleBSD, Bhyve com hardening PF parametrizado e Podman OCI         |

---

## 🚀 Como Navegar

Para acessar as receitas da estação de trabalho gráfica, navegue até [`desktop/`](desktop/README.md).
