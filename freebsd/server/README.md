# 😈 FreeBSD Server (KVM / QEMU Guest) — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar a máquina virtual FreeBSD Server em execução sob KVM/QEMU.

---

## 🎯 Finalidade

Organiza a configuração da VM servidora FreeBSD: agente de integração QEMU para KVM, console de alta resolução e ferramenta de conexão dinâmica.

> ℹ️ **Infraestrutura Base & CLI:** As receitas universais de elevação `doas`, parâmetros de kernel e ferramentas de terminal residem em [`../common/`](../common/README.md).

---

## 📂 Catálogo de Arquivos

| Arquivo                                                                | Tipo       | Descrição                                                                 |
| :--------------------------------------------------------------------- | :--------- | :------------------------------------------------------------------------ |
| **[`system/guest.sh`](system/guest.sh)**                               | Receita    | QEMU Guest Agent e console de alta resolução Spleen 12x24                 |
| **[`../../common/system/persist.sh`](../../common/system/persist.sh)** | Receita    | Elevação com `doas` e `sudo` com senha e persistência de sessão (0440)    |
| **[`connect.sh`](connect.sh)**                                         | Ferramenta | Conexão SSH e cópia SCP automática via detecção dinâmica de IP do `virsh` |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Conectar via SSH na VM FreeBSD:

```sh
sh freebsd/server/connect.sh
```

Copiar arquivos via SCP:

```sh
sh freebsd/server/connect.sh scp ./meu_arquivo freebsd@vm:/tmp/
```
