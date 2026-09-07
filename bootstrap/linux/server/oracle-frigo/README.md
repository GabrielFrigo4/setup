# ☁️ Oracle Frigo Server — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar a instância de nuvem `oracle-frigo` na OCI.

---

## 🎯 Finalidade

Esta pasta organiza as aplicações e configurações específicas do servidor pessoal de cloud `oracle-frigo`.

> ℹ️ **Infraestrutura Base Multi-Distro:** As receitas de infraestrutura compartilhada (Swap agnóstico, elevação `doas`, firewall e containers) residem em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo de Receitas

| Recurso         | Receita                  | Descrição                                               |
| :-------------- | :----------------------- | :------------------------------------------------------ |
| **`caddy.sh`**  | [`caddy.sh`](caddy.sh)   | Reverse proxy Caddy para domínios `gabrielfrigo.dev.br` |
| **`resume.sh`** | [`resume.sh`](resume.sh) | Serviço systemd para a aplicação Resume                 |
| **`game.sh`**   | [`game.sh`](game.sh)     | Serviço systemd para o servidor Game                    |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute a receita desejada diretamente no terminal do servidor:

```sh
# Configurar Proxy Caddy
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/server/oracle-frigo/caddy.sh | sh

# Configurar Serviço Resume
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/server/oracle-frigo/resume.sh | sh
```
