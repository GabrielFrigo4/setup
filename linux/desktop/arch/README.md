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
| **`servers/`**        | [`servers/kvm.sh`](servers/kvm.sh)                 | Chaves de servidores e integração de virtualização KVM   |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Configurar aceleração de hardware no Arch Linux:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/linux/desktop/arch/desktop/hardware.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/linux/desktop/arch/desktop/hardware.sh) | sh
```
