# 📦 FreeBSD Container — Jails, BastilleBSD & Podman

> Receitas para provisionamento do subsistema de FreeBSD Jails, automação com Bastille e Podman nativo.

---

## 🎯 Finalidade

Esta pasta organiza a ativação de containers de sistema e de aplicação no FreeBSD através do subsistema nativo de Jails, do orquestrador BastilleBSD e da engine OCI Podman.

---

## 📂 Catálogo de Receitas

| Receita                      | Tipo          | Descrição                                                                             |
| :--------------------------- | :------------ | :------------------------------------------------------------------------------------ |
| [`jails.sh`](jails.sh)       | Receita Shell | Ativação do subsistema nativo de FreeBSD Jails no `rc.conf` e criação de `/usr/jails` |
| [`bastille.sh`](bastille.sh) | Receita Shell | Instalação e ativação do gerenciador de templates BastilleBSD                         |
| [`podman.sh`](podman.sh)     | Receita Shell | Instalação do Podman nativo para execução de containers OCI no FreeBSD                |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute a receita desejada copiando o link RAW para o terminal:

```sh
# Provisionar Jails
fetch -o - https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/freebsd/container/jails.sh | sh

# Instalar Podman nativo
fetch -o - https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/freebsd/container/podman.sh | sh
```
