# ⚙️ System Hardening & Persistence Policies

> Receitas transversais de políticas de privilégio, persistência e endurecimento de sistema operacional.

---

## 🎯 Finalidade

Esta pasta concentra receitas de ajuste de políticas administrativas (como regras de elevação sem senha para grupos autorizados, persistência de configuração e modo estrito) compartilhadas entre ambientes UNIX.

---

## 📂 Catálogo de Arquivos

| Arquivo                    | Plataforma      | Descrição                                                       |
| :------------------------- | :-------------- | :-------------------------------------------------------------- |
| [`nopass.sh`](nopass.sh)   | Linux / FreeBSD | Configura elevação `doas`/`sudo` sem senha para o administrador |
| [`persist.sh`](persist.sh) | Linux / FreeBSD | Configura persistência de sessão e cache de autenticação        |
| [`strict.sh`](strict.sh)   | Linux / FreeBSD | Aplica políticas estritas de segurança e permissões de sistema  |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/nopass.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/persist.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/system/strict.sh"
```
