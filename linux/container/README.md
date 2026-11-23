# 📦 Linux Containers (Incus, Podman & Docker) — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar subsistemas de containers de sistema e de aplicação no Linux.

---

## 🎯 Finalidade

Esta pasta centraliza os provisionamentos de containers no Linux em simetria com o ecossistema FreeBSD ([`../../freebsd/container/`](../../freebsd/container/README.md)):

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

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/container/incus.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/linux/container/podman.sh"
```
