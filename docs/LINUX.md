# 🐧 O Ecossistema Linux

> Arquitetura, distribuições suportadas, conformidade XDG e subsistemas de virtualização/containers no Linux.

---

## 🎯 Visão Geral

O Linux é o núcleo operacional da estação de trabalho primária e da infraestrutura de nuvem deste ecossistema. Ele foi projetado sob o princípio de **Clean Host**, onde o sistema hospedeiro provê a interface gráfica (GNOME/Wayland) e os editores, enquanto toolchains de compilação pesadas rodam isoladas em containers de sistema (Incus) ou containers de aplicação (Podman).

---

## 📂 Distribuições Suportadas e Papéis

O repositório **Setup** suporta de forma atômica e declarativa as três grandes famílias do ecossistema Linux:

### 1. 🔵 Fedora Workstation (Estação Primária)

- **Papel:** Estação de trabalho principal para desenvolvimento e produtividade diária.
- **Destaques:** GNOME Wayland puro, tema Adwaita escuro, suporte oficial a Flatpak/Flathub e integração nativa com o subsistema Podman/OCI.
- **Receitas:** [`linux/desktop/fedora/`](../linux/desktop/fedora/README.md).

### 2. 🏹 Arch Linux (Ambiente Modular)

- **Papel:** Ambiente modular para experimentação avançada, testes com kernels de alto desempenho e desenvolvimento gráfico.
- **Destaques:** Gerenciador `pacman`, acesso ao AUR (`yay`), drivers bleeding-edge e inicialização via SDDM.
- **Receitas:** [`linux/desktop/arch/`](../linux/desktop/arch/README.md).

### 3. 🍥 Debian GNU/Linux (Estabilidade)

- **Papel:** Estação clássica de estabilidade de longo prazo e base para servidores.
- **Destaques:** Gerenciador `apt`, repositórios `non-free-firmware` e drivers de contingência.
- **Receitas:** [`linux/desktop/debian/`](../linux/desktop/debian/README.md).

### 4. 🪟🐧 WSL2 (Linux sob Windows)

- **Papel:** Distribuições Linux (Arch, Debian, Fedora/Rocky) rodando sob o hypervisor no Windows.
- **Destaques:** Ativação nativa do `systemd`, elevação com `doas` (`0440`) e utilitários modernos de terminal.
- **Receitas:** [`linux/wsl/`](../linux/wsl/README.md).

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

1. **Incus / LXC ([`linux/container/incus.sh`](../linux/container/incus.sh)):**
    - Containers de sistema rápidos (boot em 2s com `systemd`).
    - Ideal para compilar código, instalar SDKs de linguagens e testar automações de infraestrutura.
2. **Podman ([`linux/container/podman.sh`](../linux/container/podman.sh)):**
    - Engine OCI rootless e daemonless para microsserviços, bancos de dados temporários e containers de aplicação.
3. **KVM / QEMU ([`linux/desktop/arch/virtualization/qemu.sh`](../linux/desktop/arch/virtualization/qemu.sh)):**
    - Virtualização completa Type-1 para executar o FreeBSD Server e outros sistemas operacionais em máquinas virtuais com aceleração de hardware VirtIO.

---

## ⚡ Gerenciamento Python Moderno: Astral `uv`

Para execução de scripts, criação de ambientes virtuais efêmeros e gerenciamento de ferramentas CLI Python com velocidade compilada em Rust:

- **Fedora Workstation:** `sudo dnf install uv`
- **Arch Linux:** `sudo pacman -S uv`
- **Debian / Ubuntu:** `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Destaque:** `uv` substitui integralmente a lentidão do `pip` e `virtualenv`, operando com cache unificado em conformidade com o XDG Base Directory (`~/.cache/uv`).

---

## 🎮 Modern Shader Toolchains & Vulkan no Linux

Para compilação avançada de shaders HLSL/Slang para SPIR-V e pipelines gráficos modernos:

-- **Arch Linux:** `pacman -S shader-slang directx-shader-compiler shaderc glslang vulkan-icd-loader vulkan-headers vulkan-tools spirv-cross`
-- **Debian / Ubuntu:** `apt install slang-compiler libshaderc-dev glslang-tools libvulkan-dev vulkan-tools spirv-cross`
-- **Fedora:** `shader-slang` via COPR `rustyclanker/slang`, `shaderc`, `glslang`, `vulkan-loader-devel`, `spirv-cross-devel`
-- **Receita Canônica Universal:** [`common/graphics/shaders.sh`](../common/graphics/shaders.sh) provê auto-detecção via gerenciador de pacotes ou fallback dinâmico oficial via GitHub para `~/.local/opt/` com wrappers em `~/.local/bin/`.

---

## ☁️ Servidores em Nuvem (OCI & Magalu Cloud)

Para servidores remotos (Oracle Cloud Infrastructure e Magalu Cloud):

- As receitas universais residem em [`linux/common/`](../linux/common/README.md) (Swap agnóstico de 2GB, `doas.conf` com permissões `0440` e regras de firewall).
- As instâncias dedicadas ([`oracle-personal`](../linux/server/oracle-personal/README.md) e [`oracle-venture`](../linux/server/oracle-venture/README.md)) contêm os proxies reversos Caddy e os daemons de aplicações (`resume`, `game`, `catalogo`).
- Conexão unificada via SSH/SCP através do script [`linux/server/connect.sh`](../linux/server/connect.sh) consumindo credenciais do Vault.

---

## 🖥️ Consoles Virtuais TTY & Cursor Estático (Spleen 12x24)

Para garantir legibilidade nítida e ergonomia visual em consoles de emergência e recuperação (`/dev/tty[1-6]`) em telas modernas (1080p a 4K):

1. **Tipografia Spleen Dinâmica & Suporte Multi-Monitor:** A receita [`linux/common/system/console.sh`](../linux/common/system/console.sh) instala as variantes da fonte Spleen e integra o escalonador dinâmico [`vconsole-autofont`](../linux/common/system/vconsole-autofont.sh).
    - **A Tabela Canônica de Resoluções:**
        - $\le 1080$p (Full HD / Standard): `spleen-12x24` ($160 \times 45$ caracteres)
        - $1081$ a $2159$p (2K / QHD / 1440p): `spleen-16x32` ($160 \times 45$ caracteres)
        - $\ge 2160$p (4K UHD): `spleen-32x64` ($120 \times 33$ caracteres) ou `spleen-16x32` ($240 \times 67$ denso via `SPLEEN_DENSE=1`)
    - **Algoritmo de Detecção Multi-Monitor:** Em cenários com múltiplos monitores conectados (onde o `fbcon` clona o terminal), o script avalia todos os conectores ativos em `/sys/class/drm/card*-*/modes` e adota a **maior altura vertical detectada**, prevenindo texto microscópico em telas de alta densidade sem prejudicar monitores convencionais.
    - **Neutralidade de Inits (Systemd e Não-Systemd / Devuan / OpenRC):**
        - **Systemd:** Drop-in em `/etc/systemd/system/systemd-vconsole-setup.service.d/autofont.conf` com `ExecStartPre=-/usr/local/libexec/vconsole-autofont`.
        - **Udev / Eudev Universal:** Regra `/etc/udev/rules.d/90-vconsole-autofont.rules` executando sob eventos `vtconsole` de DRM independente do init.
        - **SysVinit (Devuan) & OpenRC (Alpine/Gentoo):** Instalação automática do serviço em `/etc/init.d/vconsole-autofont` integrado via `update-rc.d` ou `rc-update`.
        - **Console-Setup:** Sincronização direta de `FONTSIZE` em `/etc/default/console-setup` e recarga via `setupcon`.
2. **Prevenção do Bug Ciano em Fontes de 512 Glifos:** Fontes de 512 glifos ativam `vc_hi_font_mask = 0x0100` no kernel Linux, deslocando atributos de primeiro plano (bits 9-11) e fundo (bits 13-15). A macro do kernel `#define CUR_BG 0x7000` (bits 12-14) no driver VT assume 256 glifos, causando distorção ciano quando flags automáticas de fundo são usadas.
3. **Parâmetro Canônico de Kernel:** Configurado no GRUB e `systemd-boot` como `vt.cur_default=0xee10` (`60944` em decimal), que corresponde matematicamente a `CUR_MAKE(16, 238, 0)`:
    - `p1 = 16` (`CUR_SW` isolado, sem invocar as flags de fundo com bug).
    - `p2 = 238` (`0xee = 11101110b`, máscara XOR precisa que inverte simultaneamente bits 13-15 de fundo e bits 9-11 de primeiro plano).
    - `p3 = 0`.
4. **Desativação Total de Pisque:**
    - Kernel/driver: `cursor_blink 0` via `/etc/tmpfiles.d/console-cursor.conf`.
    - Tela pré-login: Injeção de `\033%G\033[?16;238;0c` no `/etc/issue`.
    - Runtime ativo: Atualização imediata em `/dev/tty[1-6]`.
