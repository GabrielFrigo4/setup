# 💿 Dynamic ISO Images — Catálogo de Receitas de Download

> Receitas modulares em POSIX Shell (`.sh`) para descoberta dinâmica, download e validação criptográfica das imagens ISO estáveis mais recentes de sistemas operacionais.

---

## 🎯 Finalidade

Automatizar a obtenção de mídias de instalação oficiais sem codificar versões obsoletas ou estáticas em código. Cada receita:

1. Consulta os repositórios e espelhos canônicos oficiais via HTTP/HTTPS.
2. Resolve dinamicamente a versão estável mais recente do sistema operacional.
3. Detecta inteligentemente o destino (datastore de hypervisor `/zroot/vm/.iso` no FreeBSD bhyve ou `/var/lib/libvirt/images` no Linux KVM, ou o diretório local para pendrives de boot).
4. Realiza o download seguro e valida a integridade com a soma criptográfica canônica (SHA256, SHA512 ou MD5).

---

## 📂 Catálogo de Sistemas Operacionais

| Script                             | Sistema Operacional | Método de Descoberta                                         | Validação de Integridade   |
| :--------------------------------- | :------------------ | :----------------------------------------------------------- | :------------------------- |
| **[`alpine.sh`](alpine.sh)**       | Alpine Linux Virt   | `https://dl-cdn.alpinelinux.org/alpine/latest-stable/`       | SHA256 (`.iso.sha256`)     |
| **[`arch.sh`](arch.sh)**           | Arch Linux Live     | `https://geo.mirror.pkgbuild.com/iso/latest/`                | SHA256 (`sha256sums.txt`)  |
| **[`debian.sh`](debian.sh)**       | Debian GNU/Linux    | `https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/` | SHA256 (`SHA256SUMS`)      |
| **[`devuan.sh`](devuan.sh)**       | Devuan GNU+Linux    | `https://files.devuan.org/devuan_daedalus/installer-iso/`    | SHA256 (`SHA256SUMS.txt`)  |
| **[`dragonfly.sh`](dragonfly.sh)** | DragonFly BSD       | `https://mirror-master.dragonflybsd.org/iso-images/`         | MD5 (`md5.txt`)            |
| **[`fedora.sh`](fedora.sh)**       | Fedora Server       | `https://fedoraproject.org/server/download`                  | SHA256 (`CHECKSUM`)        |
| **[`freebsd.sh`](freebsd.sh)**     | FreeBSD             | `https://download.freebsd.org/releases/amd64/amd64/`         | SHA256 (`CHECKSUM.SHA256`) |
| **[`netbsd.sh`](netbsd.sh)**       | NetBSD              | `https://cdn.netbsd.org/pub/NetBSD/`                         | SHA512 (`SHA512`)          |
| **[`openbsd.sh`](openbsd.sh)**     | OpenBSD             | `https://cdn.openbsd.org/pub/OpenBSD/`                       | SHA256 (`SHA256`)          |
| **[`void.sh`](void.sh)**           | Void Linux Base     | `https://repo-default.voidlinux.org/live/current/`           | SHA256 (`sha256sum.txt`)   |

---

## ⚙️ Opções Universais da CLI

Todos os scripts compartilham a mesma interface de linha de comando:

| Flag                 | Descrição                                                                          |
| :------------------- | :--------------------------------------------------------------------------------- |
| `-n`, `--dry-run`    | Apenas resolve a versão remota, testa conectividade e valida links sem baixar      |
| `-l`, `--local`      | Força download no diretório atual `$PWD` (ideal para pendrives e mídia física)     |
| `-d`, `--datastore`  | Salva no datastore do hypervisor (`/zroot/vm/.iso` no FreeBSD ou libvirt no Linux) |
| `-o`, `--output DIR` | Define um diretório de destino customizado                                         |
| `-h`, `--help`       | Exibe a ajuda da linha de comando                                                  |

---

## 🚀 Exemplos de Uso

### 1. Testar resolução e links remotos (Dry-Run)

Validar se o espelho e a versão mais recente estão acessíveis:

```sh
./Setup/common/iso/alpine.sh -n
./Setup/common/iso/arch.sh -n
./Setup/common/iso/debian.sh -n
./Setup/common/iso/devuan.sh -n
./Setup/common/iso/dragonfly.sh -n
./Setup/common/iso/fedora.sh -n
./Setup/common/iso/freebsd.sh -n
./Setup/common/iso/netbsd.sh -n
./Setup/common/iso/openbsd.sh -n
./Setup/common/iso/void.sh -n
```

### 2. Baixar localmente para criação de Pendrive Bootável (`-l`)

Baixar diretamente no diretório atual sem tocar nos discos de VM:

```sh
cd /mnt/pendrive || cd /tmp
~/Documents/Environment/Setup/common/iso/freebsd.sh -l
```

### 3. Provisionamento para Máquinas Virtuais (Bhyve / KVM)

Salvar automaticamente em `/zroot/vm/.iso` se existir no FreeBSD:

```sh
./Setup/common/iso/debian.sh
```

### 4. Execução Remota via GitHub (Zero-Clone)

Baixar Debian mais recente sem clonar o repositório Setup:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/iso/debian.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/iso/debian.sh) | sh -s -- -l
```
