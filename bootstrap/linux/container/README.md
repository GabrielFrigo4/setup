# 📦 Linux Containers (Incus, Podman & Docker) — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar subsistemas de containers de sistema e de aplicação no Linux.

---

## 🎯 Finalidade

Esta pasta centraliza os provisionamentos de containers no Linux em perfeita simetria com o ecossistema FreeBSD Jails ([`../../freebsd/container/`](../../freebsd/container/README.md)):

- **Containers de Sistema (Incus / LXC):** Ambientes completos com systemd e kernel compartilhado para desenvolvimento isolado (Clean Host).
- **Containers de Aplicação (Podman & Docker):** Engines OCI rootless e daemonless para microserviços e desenvolvimento web.

---

## 📂 Catálogo de Receitas

| Recurso         | Receita                  | Descrição                                                                                 |
| :-------------- | :----------------------- | :---------------------------------------------------------------------------------------- |
| **`incus.sh`**  | [`incus.sh`](incus.sh)   | Gerenciador de containers de sistema Incus, daemons LXC e mapeamento de `subuid`/`subgid` |
| **`podman.sh`** | [`podman.sh`](podman.sh) | Engine Podman rootless, daemonless e ativação de linger de usuário                        |
| **`docker.sh`** | [`docker.sh`](docker.sh) | Engine Docker CE oficial com repositórios e plugins de build                              |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita diretamente via terminal no Linux:

```sh
# Provisionar Incus (Containers de Sistema)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/container/incus.sh | sh

# Provisionar Podman (Containers de Aplicação)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/container/podman.sh | sh
```
