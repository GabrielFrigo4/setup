# 📦 FreeBSD Container — Jails, BastilleBSD, Bhyve & Podman

> Receitas para provisionamento do subsistema de FreeBSD Jails, automação com Bastille, hypervisor Bhyve com hardening PF e Podman nativo.

---

## 🎯 Finalidade

Esta pasta organiza a ativação de containers de sistema, virtualização completa e containers OCI no FreeBSD através do subsistema nativo de Jails, do orquestrador BastilleBSD, do hypervisor Bhyve (`vm-bhyve` + `/etc/pf.conf` parametrizado) e da engine Podman.

---

## 📂 Catálogo de Receitas

| Receita                      | Tipo          | Descrição                                                                                   |
| :--------------------------- | :------------ | :------------------------------------------------------------------------------------------ |
| [`jails.sh`](jails.sh)       | Receita Shell | Ativação do subsistema nativo de FreeBSD Jails no `rc.conf` e criação de `/usr/jails`       |
| [`bastille.sh`](bastille.sh) | Receita Shell | Instalação e ativação do gerenciador de templates BastilleBSD                               |
| [`bhyve.sh`](bhyve.sh)       | Receita Shell | Hypervisor Bhyve (`vm-bhyve`), NFSv3 e firewall PF hardening com autodetecção de interfaces |
| [`podman.sh`](podman.sh)     | Receita Shell | Instalação do Podman nativo para execução de containers OCI no FreeBSD                      |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/container/jails.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/container/bastille.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/container/bhyve.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/container/podman.sh"
```
