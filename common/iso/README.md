# 💿 Dynamic ISO Images — Download & Verificação

> Motor único em POSIX Shell ([`download.sh`](download.sh)) para descoberta dinâmica, download e validação criptográfica das imagens ISO estáveis mais recentes.

---

## 🎯 Finalidade

Automatizar a obtenção de mídias oficiais sem codificar versões estáticas. O script [`download.sh`](download.sh):

1. Consulta os espelhos oficiais via HTTP/HTTPS e resolve dinamicamente a versão estável mais recente.
2. Seleciona o destino adequado (`/zroot/vm/.iso` no FreeBSD bhyve, `/var/lib/libvirt/images` no Linux libvirt ou `$PWD` com `-l`).
3. Baixa a imagem e valida sua integridade criptográfica (`SHA256`, `SHA512` ou `MD5`).

---

## 📂 Sistemas Operacionais Suportados (`download.sh`)

| Alvo (`<sistema>`) | Sistema Operacional | Espelho Oficial                                              | Validação de Integridade   |
| :----------------- | :------------------ | :----------------------------------------------------------- | :------------------------- |
| `alpine`           | Alpine Linux Virt   | `https://dl-cdn.alpinelinux.org/alpine/latest-stable/`       | SHA256 (`.iso.sha256`)     |
| `arch`             | Arch Linux Live     | `https://geo.mirror.pkgbuild.com/iso/latest/`                | SHA256 (`sha256sums.txt`)  |
| `debian`           | Debian GNU/Linux    | `https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/` | SHA256 (`SHA256SUMS`)      |
| `devuan`           | Devuan GNU+Linux    | `https://files.devuan.org/devuan_daedalus/installer-iso/`    | SHA256 (`SHA256SUMS.txt`)  |
| `dragonfly`        | DragonFly BSD       | `https://mirror-master.dragonflybsd.org/iso-images/`         | MD5 (`md5.txt`)            |
| `fedora`           | Fedora Server       | `https://fedoraproject.org/server/download`                  | SHA256 (`CHECKSUM`)        |
| `freebsd`          | FreeBSD             | `https://download.freebsd.org/releases/amd64/amd64/`         | SHA256 (`CHECKSUM.SHA256`) |
| `netbsd`           | NetBSD              | `https://cdn.netbsd.org/pub/NetBSD/`                         | SHA512 (`SHA512`)          |
| `openbsd`          | OpenBSD             | `https://cdn.openbsd.org/pub/OpenBSD/`                       | SHA256 (`SHA256`)          |
| `void`             | Void Linux Base     | `https://repo-default.voidlinux.org/live/current/`           | SHA256 (`sha256sum.txt`)   |

---

## ⚙️ Opções da CLI

| Flag                 | Descrição                                                                          |
| :------------------- | :--------------------------------------------------------------------------------- |
| `-n`, `--dry-run`    | Apenas resolve a versão remota, testa conectividade e valida links sem baixar      |
| `-l`, `--local`      | Força download no diretório atual `$PWD` (ideal para pendrives e mídia física)     |
| `-d`, `--datastore`  | Salva no datastore do hypervisor (`/zroot/vm/.iso` no FreeBSD ou libvirt no Linux) |
| `-o`, `--output DIR` | Define um diretório de destino customizado                                         |
| `list`               | Lista todos os identificadores de sistemas suportados                              |
| `-h`, `--help`       | Exibe a ajuda da linha de comando                                                  |

---

## 🚀 Exemplos de Uso

```sh
sh common/iso/download.sh list
sh common/iso/download.sh -n freebsd
sh common/iso/download.sh -n debian
sh common/iso/download.sh -l freebsd
sh common/iso/download.sh debian
```
