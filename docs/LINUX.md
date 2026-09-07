# 🐧 O Ecossistema Linux

> Arquitetura, distribuições suportadas, conformidade XDG e subsistemas de virtualização/containers no Linux.

---

## 🎯 Visão Geral

O Linux é o núcleo operacional da estação de trabalho primária e da infraestrutura de nuvem deste ecossistema. Ele foi projetado sob o princípio de **Clean Host**, onde o sistema hospedeiro provê a interface gráfica (GNOME/Wayland) e os editores, enquanto toolchains de compilação pesadas rodam isoladas em containers de sistema (Incus) ou containers de aplicação (Podman).

---

## 📂 Distribuições Suportadas e Papéis

O repositório **Configuration** suporta de forma atômica e declarativa as três grandes famílias do ecossistema Linux:

### 1. 🔵 Fedora Workstation (Estação Primária)

- **Papel:** Estação de trabalho principal para desenvolvimento e produtividade diária.
- **Destaques:** GNOME Wayland puro, tema Adwaita escuro, suporte oficial a Flatpak/Flathub e integração nativa com o subsistema Podman/OCI.
- **Receitas:** [`bootstrap/linux/desktop/fedora/`](../bootstrap/linux/desktop/fedora/README.md).

### 2. 🏹 Arch Linux (Ambiente Modular)

- **Papel:** Ambiente modular para experimentação avançada, testes com kernels de alto desempenho e desenvolvimento gráfico.
- **Destaques:** Gerenciador `pacman`, acesso ao AUR (`yay`), drivers bleeding-edge e inicialização via SDDM.
- **Receitas:** [`bootstrap/linux/desktop/arch/`](../bootstrap/linux/desktop/arch/README.md).

### 3. 🍥 Debian GNU/Linux (Estabilidade)

- **Papel:** Estação clássica de estabilidade de longo prazo e base para servidores.
- **Destaques:** Gerenciador `apt`, repositórios `non-free-firmware` e drivers de contingência.
- **Receitas:** [`bootstrap/linux/desktop/debian/`](../bootstrap/linux/desktop/debian/README.md).

### 4. 🪟🐧 WSL2 (Linux sob Windows)

- **Papel:** Distribuições Linux (Arch, Debian, Fedora/Rocky) rodando sob o hypervisor no Windows.
- **Destaques:** Ativação nativa do `systemd`, elevação com `doas` (`0440`) e utilitários modernos de terminal.
- **Receitas:** [`bootstrap/linux/wsl/`](../bootstrap/linux/wsl/README.md).

---

## 🌐 Conformidade com XDG Base Directory

No Linux, todas as configurações geradas pelo repositório seguem estritamente a especificação **XDG Base Directory**:

- **`$XDG_CONFIG_HOME` (`~/.config`):** Destino exclusivo para arquivos de configuração (Helix, Neovim, Micro, Clangd, Zed).
- **`$XDG_DATA_HOME` (`~/.local/share`):** Fontes de usuário (`~/.local/share/fonts/`), temas e launchers `.desktop`.
- **`$XDG_STATE_HOME` (`~/.local/state`):** Logs e histórico de aplicações.
- **`$XDG_CACHE_HOME` (`~/.cache`):** Caches temporários.

Nenhuma ferramenta deve poluir a raiz de `$HOME` a menos que seja estritamente exigido por compatibilidade legada (ex: `.clang-format`, `.prettierrc`, `.vimrc`).

---

## 📦 Containers e Virtualização no Linux

O Linux implementa a camada de isolamento do **Clean Host** através de três ferramentas complementares:

1. **Incus / LXC ([`bootstrap/linux/container/incus.sh`](../bootstrap/linux/container/incus.sh)):**
    - Containers de sistema rápidos (boot em 2s com `systemd`).
    - Ideal para compilar código, instalar SDKs de linguagens e testar automações de infraestrutura.
2. **Podman ([`bootstrap/linux/container/podman.sh`](../bootstrap/linux/container/podman.sh)):**
    - Engine OCI rootless e daemonless para microsserviços, bancos de dados temporários e containers de aplicação.
3. **KVM / QEMU ([`bootstrap/linux/desktop/arch/virtualization/qemu.sh`](../bootstrap/linux/desktop/arch/virtualization/qemu.sh)):**
    - Virtualização completa Type-1 para executar o FreeBSD Server e outros sistemas operacionais em máquinas virtuais com aceleração de hardware VirtIO.

---

## ☁️ Servidores em Nuvem (OCI & Magalu Cloud)

Para servidores remotos (Oracle Cloud Infrastructure e Magalu Cloud):

- As receitas universais residem em [`bootstrap/linux/common/`](../bootstrap/linux/common/README.md) (Swap agnóstico de 2GB, `doas.conf` com permissões `0440` e regras de firewall).
- As instâncias dedicadas ([`oracle-frigo`](../bootstrap/linux/server/oracle-frigo/README.md) e [`oracle-orbs`](../bootstrap/linux/server/oracle-orbs/README.md)) contêm os proxies reversos Caddy e os daemons de aplicações (`resume`, `game`, `catalogo`).
- Conexão unificada via SSH/SCP através do script [`bootstrap/linux/server/connect.sh`](../bootstrap/linux/server/connect.sh) consumindo credenciais do Vault.
