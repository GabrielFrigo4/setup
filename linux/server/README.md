# ☁️ Servidores Linux em Nuvem (Oracle Cloud & VPS)

> Provisionamento de aplicações e ferramenta de conexão para servidores VPS na nuvem (Oracle Cloud / Ubuntu / Debian / Rocky Linux).

---

## 🎯 Finalidade

Reúne receitas atômicas para configurar aplicações em instâncias remotas na nuvem (`oracle-frigo`, `oracle-orbs`, Magalu Cloud) e a ferramenta unificada de conexão remota (SSH / SCP) integrada ao Vault.

> ℹ️ **Infraestrutura Base Multi-Distro:** As receitas universais (Swap agnóstico, elevação `doas`, firewall inteligente e Podman) residem em [`../common/`](../common/README.md).

---

## 📂 Catálogo de Recursos & Servidores

| Recurso / Servidor                                                     | Tipo               | Descrição                                                                            |
| :--------------------------------------------------------------------- | :----------------- | :----------------------------------------------------------------------------------- |
| **[`connect.sh`](connect.sh)**                                         | Ferramenta         | Conexão SSH unificada aos servidores (`sh connect.sh frigo` ou `sh connect.sh orbs`) |
| **[`../../common/system/persist.sh`](../../common/system/persist.sh)** | Receita            | Elevação com `doas` e `sudo` com senha e persistência de sessão (0440)               |
| **[`oracle-frigo/`](oracle-frigo/README.md)**                          | Servidor Pessoal   | Reverse proxy Caddy e serviços systemd (`resume`, `game`)                            |
| **[`oracle-orbs/`](oracle-orbs/README.md)**                            | Servidor Comercial | Reverse proxy Caddy e serviço systemd em container Podman (`catalogo`)               |

---

## 🔒 Segurança & Chaves

O script `connect.sh` consome automaticamente as variáveis (`FRIGO_SERVER_*` e `ORBS_SERVER_*`) e chaves criptográficas armazenadas no Vault (`~/.vault/keys/`). Nenhuma chave SSH ou segredo reside neste repositório.
