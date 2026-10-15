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
| **[`debian.sh`](debian.sh)**       | Debian GNU/Linux    | `https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/` | SHA256 (`SHA256SUMS`)      |
| **[`freebsd.sh`](freebsd.sh)**     | FreeBSD             | `https://download.freebsd.org/releases/amd64/amd64/`         | SHA256 (`CHECKSUM.SHA256`) |
| **[`openbsd.sh`](openbsd.sh)**     | OpenBSD             | `https://cdn.openbsd.org/pub/OpenBSD/`                       | SHA256 (`SHA256`)          |
| **[`netbsd.sh`](netbsd.sh)**       | NetBSD              | `https://cdn.netbsd.org/pub/NetBSD/`                         | SHA512 (`SHA512`)          |
| **[`dragonfly.sh`](dragonfly.sh)** | DragonFly BSD       | `https://mirror-master.dragonflybsd.org/iso-images/`         | MD5 (`md5.txt`)            |

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

```sh
# Validar se o espelho e a versão mais recente estão acessíveis
./Setup/common/iso/debian.sh -n
./Setup/common/iso/freebsd.sh -n
./Setup/common/iso/openbsd.sh -n
./Setup/common/iso/netbsd.sh -n
./Setup/common/iso/dragonfly.sh -n
```

### 2. Baixar localmente para criação de Pendrive Bootável (`-l`)

```sh
# Baixa diretamente no diretório atual sem tocar nos discos de VM
cd /mnt/pendrive || cd /tmp
~/Documents/Environment/Setup/common/iso/freebsd.sh -l
```

### 3. Provisionamento para Máquinas Virtuais (Bhyve / KVM)

```sh
# Salva automaticamente em /zroot/vm/.iso se existir no FreeBSD
./Setup/common/iso/debian.sh
```

### 4. Execução Remota via GitHub (Zero-Clone)

```sh
# Baixar Debian mais recente sem clonar o repositório Setup
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/iso/debian.sh | sh -s -- -l
```
