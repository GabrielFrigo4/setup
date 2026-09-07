# ☁️ Oracle Orbs Server — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar a instância de nuvem `oracle-orbs` na OCI.

---

## 🎯 Finalidade

Esta pasta organiza as aplicações e configurações específicas do servidor de nuvem comercial `oracle-orbs`.

> ℹ️ **Infraestrutura Base Multi-Distro:** As receitas de infraestrutura compartilhada (Swap agnóstico, elevação `doas`, firewall e containers) residem em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo de Receitas

| Recurso           | Receita                      | Descrição                                                    |
| :---------------- | :--------------------------- | :----------------------------------------------------------- |
| **`caddy.sh`**    | [`caddy.sh`](caddy.sh)       | Reverse proxy Caddy para domínios `orbs.gabrielfrigo.dev.br` |
| **`catalogo.sh`** | [`catalogo.sh`](catalogo.sh) | Serviço systemd e rede Podman para a aplicação Catalogo      |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute a receita desejada diretamente no terminal do servidor:

```sh
# Configurar serviço Catalogo
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/server/oracle-orbs/catalogo.sh | sh
```
