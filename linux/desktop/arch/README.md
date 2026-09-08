# 🏹 Arch Linux — Catálogo de Receitas

> Receitas modulares e idempotentes para provisionar estações de trabalho rodando Arch Linux.

---

## 🎯 Finalidade

Organiza a configuração do Arch Linux em módulos desacoplados: sistema base, aceleração de hardware, virtualização KVM/QEMU, editores e ferramentas de desenvolvimento.

> ℹ️ **Containers & Infraestrutura Base:** Receitas de containers (Incus, Podman, Docker) residem em [`../../container/`](../../container/README.md) e infraestrutura base (Swap, doas, Flatpak, Wireshark, Antigravity) em [`../../common/`](../../common/README.md).

---

## 📂 Catálogo de Receitas

| Categoria             | Receita                                            | Descrição                                                |
| :-------------------- | :------------------------------------------------- | :------------------------------------------------------- |
| **`system/`**         | [`system/base.sh`](system/base.sh)                 | Mirrors, SDDM e limite de journald                       |
| **`system/`**         | [`system/diagnostics.sh`](system/diagnostics.sh)   | Diagnóstico de kernel, firmware e dispositivos           |
| **`desktop/`**        | [`desktop/hardware.sh`](desktop/hardware.sh)       | Mesa, drivers de aceleração VA-API, Vulkan e regras udev |
| **`virtualization/`** | [`virtualization/qemu.sh`](virtualization/qemu.sh) | QEMU, Libvirt, Virt-Manager e rede padrão                |
| **`tools/`**          | [`tools/cli.sh`](tools/cli.sh)                     | Utilitários CLI modernos e análise estática              |
| **`editors/`**        | [`editors/editors.sh`](editors/editors.sh)         | Instalação de editores gráficos e de terminal            |
| **`apps/`**           | [`apps/desktop.sh`](apps/desktop.sh)               | Navegadores, comunicação e mídia                         |
| **`servers/`**        | [`servers/kvm.sh`](servers/kvm.sh)                 | Utilitários de controle da VM FreeBSD                    |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Copie os comandos da receita desejada e execute no terminal do Arch Linux:

```sh
# Configurar aceleração de hardware
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/linux/desktop/arch/desktop/hardware.sh | sh
```
