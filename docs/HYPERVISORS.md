# 🖥️ Hypervisors e Virtualização Completa

Enquanto os [Containers (Podman/Incus/Jails)](CONTAINERS.md) são a primeira linha de frente para isolamento de processos sobre o mesmo kernel, a **virtualização completa de hardware (VMs)** desempenha um papel estratégico insubstituível na nossa estação de trabalho.

---

## 🔄 A Simbiose Cruzada: Linux ⟷ FreeBSD

No nosso ecossistema dual, as VMs não servem para abstração teórica — elas resolvem a ponte prática entre os dois mundos:

1. **No Linux (Fedora ➔ VM FreeBSD):**
    - Quando precisamos rodar ferramentas nativas do ecossistema BSD, testar scripts POSIX estritos ou validar arquiteturas do FreeBSD enquanto estamos no Fedora, subimos uma VM FreeBSD via **KVM** (ou diretamente pelo **Incus** com `incus launch images:freebsd/14 ... --vm`).
2. **No FreeBSD (FreeBSD ➔ VM Linux):**
    - O FreeBSD é lendário para Jails e storage ZFS, mas certas ferramentas de automação e orquestração de nuvem moderna (como o **Incus** e testes com **OpenTofu / Terraform**) dependem estritamente do kernel Linux.
    - No FreeBSD, utilizamos o **bhyve** para subir uma VM Linux completa. Dentro dessa VM Linux, rodamos o Incus e o OpenTofu com desempenho nativo e isolamento total, sem forçar ferramentas incompatíveis no host FreeBSD.

---

## 🛡️ O Papel Crítico do ZFS (ZVOLs)

Em vez de usar arquivos de imagem soltos (`.qcow2`, `.vmdk`, `.raw`), todas as nossas máquinas virtuais utilizam **ZVOLs** (volumes de bloco direto providos pelo ZFS):

- **Desempenho de Bloco:** A VM escreve diretamente no volume bruto sem a sobrecarga de intermediários.
- **Snapshots Instantâneos em Nível de Bloco:** Congelamento e reversão de uma VM inteira em milissegundos.
- **Compressão Transparente:** Redução drástica do espaço em disco ocupado pelas imagens de sistema.

---

## 🛠️ Tecnologias por Plataforma

### 1. 😈 FreeBSD: bhyve

- **O que é:** Hypervisor _Type-2_ nativo construído dentro do kernel do FreeBSD, ultraleve e sem bloatware.
- **Uso Principal:** Provisionar a VM Linux de apoio para rodar Incus e OpenTofu, além de hospedar o guest Alpine do Wifibox (quando necessário).

### 2. 🐧 Linux: KVM & Incus VMs

- **O que é:** Virtualização _Type-1_ acelerada por hardware integrada ao kernel Linux.
- **Uso Principal:** Gerenciado de forma unificada via **Incus** (`incus launch ... --vm`), permitindo criar VMs FreeBSD e Linux sob a mesma interface e sintaxe que já usamos para containers.

### 3. 🪟 Windows: Hyper-V & WSL2

- **WSL2:** Roda sobre uma VM leve no Hyper-V para prover ambiente Linux nativo.
- **Hyper-V:** Para virtualizar instâncias de teste e experimentação de binários.
