# 😈 A Família BSD

O ecossistema BSD (Berkeley Software Distribution) tem um papel central neste repositório. Embora a família englobe vários sistemas incríveis, nosso foco absoluto de engenharia está no **FreeBSD**, devido à sua robustez inigualável para infraestrutura, suporte massivo a ZFS e ecossistema de virtualização.

1.  **[FreeBSD](https://www.freebsd.org/)** (99% do nosso foco)
2.  [OpenBSD](https://www.openbsd.org/) (Focado em segurança e código limpo)
3.  [NetBSD](https://www.netbsd.org/) (Focado em portabilidade máxima)
4.  [DragonFlyBSD](https://www.dragonflybsd.org/) (Focado em performance SMP e sistema de arquivos HAMMER)

---

## FreeBSD: O Cidadão de Primeira Classe

O FreeBSD alinha-se perfeitamente à nossa filosofia de isolamento e reprodutibilidade (conforme a [Filosofia do Projeto](PHILOSOPHY.md)). Ele trata o sistema base e os softwares instalados pelo usuário como entidades estritamente separadas.

### 1. Caminhos Específicos (Atenção ao `/usr/local/`)

No FreeBSD, qualquer pacote ou software que _não_ faça parte do sistema base (kernel e utilitários da _userland_ principal) é instalado em `/usr/local/`. Isso significa que:

- **Shells:** Enquanto no Linux o Zsh ou o Bash podem residir em `/usr/bin/zsh` ou `/bin/bash`, no FreeBSD eles **sempre** estarão em `/usr/local/bin/zsh` e `/usr/local/bin/bash`.
- **O Shell Padrão:** O FreeBSD vem com o `sh` e o `tcsh/csh` no sistema base. Nossos scripts de bootstrap automatizam a instalação e transição para os nossos shells favoritos (zsh/bash).
- **Konsole:** Perfis de terminal importados do Linux (que esperam o bash em `/bin/bash`) falharão silenciosamente no FreeBSD. Nossos scripts de software adaptam automaticamente os perfis do Konsole (e outros terminais) para injetar o caminho correto (`/usr/local/bin/...`) dependendo do SO hospedeiro.

### 2. O Ecossistema de Containers (Jails)

Como detalhado no documento sobre [Containers](CONTAINERS.md), o FreeBSD brilha com o **Jails**.
Não instalamos dependências de desenvolvimento no host FreeBSD. Em vez disso:

- Utilizamos o **ZFS** para criar datasets raízes dedicados.
- Provisionamos novos Jails (geralmente orquestrados pelo **BastilleBSD**) para encapsular completamente serviços, bancos de dados e ferramentas de build.

### 3. Hypervisors (bhyve)

Para executar código que exige um kernel Linux ou para virtualizar outras instâncias, tiramos proveito do **bhyve**, o hypervisor nativo do FreeBSD. Em conjunto com ZVOLs (discos virtuais baseados em ZFS), criamos máquinas virtuais de altíssima performance para complementar nosso ambiente _Clean Host_. O dimensionamento de memória segue a fórmula proporcional de 16 partes: 1/16 para a VM Bhyve (1 GB em host de 16 GB, piso 1 GB e teto 2 GB), 4/16 para o ZFS ARC (4 GB em host de 16 GB, piso 1 GB e teto 4 GB) e 11/16 livres para o Host e aceleração GPU DRM (11 GB). Veja a documentação de [Hypervisors](HYPERVISORS.md).

### 4. Perfis Unificados do Konsole (Linux & FreeBSD)

Os perfis do Konsole no repositório [Profile](https://github.com/GabrielFrigo4/profile) (`terminals/konsole/`) são **100% compartilhados** entre Linux e FreeBSD:

- **Resolução Dinâmica via `/usr/bin/env`:** Os perfis apontam para `Command=/usr/bin/env bash`, `Command=/usr/bin/env zsh` e `Command=/usr/bin/env sh`. Isso resolve dinamicamente o executável tanto em `/bin/` (Linux) quanto em `/usr/local/bin/` (FreeBSD), eliminando duplicações de configuração.
- **Shell.profile:** Configura `Environment=SHELL_INIT=1` e `Command=/usr/bin/env sh`, utilizado pelo ecossistema Shell para inicialização controlada e leve.
- **Instalação:** Basta linkar os perfis de `Profile/terminals/konsole/` para `~/.local/share/konsole/`.

### 5. Hardware e Periféricos no FreeBSD

- **Wi-Fi Nativo:** Graças aos avanços recentes do time do FreeBSD, a maioria dos chipsets Wi-Fi modernos agora é suportada nativamente pelo kernel (`wpa_supplicant`), tornando o uso de ferramentas como o Wifibox um recurso pontual de contingência, e não uma dependência obrigatória.
- **Áudio & Periféricos:** Fones e microfones USB (headsets) funcionam de forma nativa e estável através do subsistema OSS do FreeBSD (`/dev/dsp*`) e PulseAudio. O script artesanal em `devices/audio.sh` provê uma rota adicional para streaming via Android quando necessário.

### 6. Ecossistema Python de Alta Performance: Astral `uv`

Para gerenciamento de runtimes Python, ambientes virtuais e ferramentas CLI com velocidade nativa em Rust, adotamos o **`uv`**:

- **Instalação via Pacotes:** `pkg install devel/uv` (origem canônica do port, sem hardcodar versões de runtime).
- **Instalação Standalone:** `curl -LsSf https://astral.sh/uv/install.sh | sh`.
- **Automação:** Integrado na receita canônica universal [`common/cli/core.sh`](../common/cli/core.sh).

### 7. Modern Shader Toolchains & Vulkan (FreeBSD & Linuxlator)

- **Vulkan & Shaders Nativos (`pkg`):** `vulkan-loader`, `vulkan-headers`, `vulkan-tools`, `glslang`, `shaderc`, `spirv-cross` integrados via gerenciador de pacotes do sistema.
- **Slang (`slangc`) & DXC (`dxc`):** Provisionados via Linuxlator com marcação ELF (`brandelf -t Linux`) e wrappers em `~/.local/bin/` através da receita universal [`common/graphics/shaders.sh`](../common/graphics/shaders.sh).

### 8. Catálogo de Receitas Modulares do FreeBSD

Seguindo a simetria do repositório, as receitas do FreeBSD residem em [`freebsd/`](../freebsd/README.md):

- **[`common/`](../freebsd/common/README.md):** `system/sysctl.sh` (parâmetros de kernel e áudio) e elevação `system/nopass.sh`. Ferramentas de terminal e compiladores residem em [`common/`](../common/README.md).
- **[`container/`](../freebsd/container/README.md):** `jails.sh` (Jails nativas), `bastille.sh` (BastilleBSD) e `podman.sh` (Podman OCI nativo).
- **[`desktop/`](../freebsd/desktop/README.md):** `gui/kde.sh` (KDE Plasma 6), `ports/ports.sh`, `emulation/compat.sh` e `devices/audio.sh` (Wireshark universal em [`common/security/`](../common/security/README.md)).
- **[`server/`](../freebsd/server/README.md):** `system/guest.sh` (QEMU Guest Agent para VM KVM) e `connect.sh` (conexão dinâmica SSH/SCP).

---

### 9. Estabilidade de Hardware & Kernel (GPU Hang & Wi-Fi Realtek)

Em estações de trabalho com processadores Intel modernos (Gen 12 / Alder Lake) e adaptadores Wi-Fi Realtek sob FreeBSD, os drivers operam sobre a camada de compatibilidade `LinuxKPI`. Para prevenir travamentos e esgotamento de buffers, aplicamos parâmetros canônicos de mitigação:

#### A. Prevenção de GPU Hang no Intel Alder Lake / Iris Xe (`i915kms`)

- **Sintoma:** Congelamento total da sessão Wayland (`kwin_wayland`) após um efeito dominó no motor 3D/Compute `rcs0`:
    ```text
    drmn0: [drm] GPU HANG: ecode 12:1:85dfbfff, in Renderer [104348]
    drmn0: [drm] Resetting rcs0 for preemption time out
    drmn0: [drm] Renderer[104348] context reset due to GPU hang
    drmn0: [drm] GPU HANG: ecode 12:1:85dfffff, in kwin_wayland [101380]
    drmn0: [drm] Resetting rcs0 for preemption time out
    drmn0: [drm] kwin_wayland[101380] context reset due to GPU hang
    drmn0: [drm] GPU HANG: ecode 12:1:859ffffb, in QSGRenderThread [101660]
    drmn0: [drm] Resetting rcs0 for preemption time out
    drmn0: [drm] CanvasRenderer[104369] context reset due to GPU hang
    drmn0: [drm] GPU HANG: ecode 12:1:86d8ffe0, in CanvasRenderer [104369]
    ```
- **Causa Raiz & Tuning de Microcódigo:** Além dos estados profundos de economia de display (_Display C-States_, _PSR_, _PSR2 Selective Fetch_ e _FBC_), a submissão via GuC (`compat.linuxkpi.i915_enable_guc="1"` ou `"3"`) induz instabilidades e travamentos de anel (_GPU ring hangs_) na camada LinuxKPI sob pressão de RAM no FreeBSD 15.1. A mitigação definitiva consiste em manter o escalonador estável via CPU enquanto se autentica e ativa exclusivamente o microcódigo **HuC** (`compat.linuxkpi.i915_enable_guc="2"`), assegurando decodificação e aceleração de mídia eficientes sem submissão instável de comandos pelo GuC.
- **Solução Definitiva:** Adicionar os parâmetros no `/boot/loader.conf` para desativar completamente os estados de economia do painel (incluindo `psr2_sel_fetch`) e ativar apenas o firmware **HuC** (`2` = HuC ativado, GuC submission desativado):
    ```ini
    compat.linuxkpi.i915_enable_psr="0"
    compat.linuxkpi.i915_enable_psr2_sel_fetch="0"
    compat.linuxkpi.i915_enable_fbc="0"
    compat.linuxkpi.i915_enable_dc="0"
    compat.linuxkpi.i915_enable_guc="2"
    ```
- **Tratamento de Sintaxe (`sysrc` vs `/boot/loader.conf`):** O comando `sysrc` rejeita nomes de variáveis contendo pontos (`.`) como `compat.linuxkpi.*`. Por isso, a receita de provisionamento [`system.sh`](../freebsd/desktop/system/system.sh) implementa a função `_set_loader_tunable` com manipulação idempotente direta.
- **Drivers, Firmwares & VA-API:** Garantir o uso do pacote moderno `drm-61-kmod` (baseado no Linux 6.1) em vez do legado `drm-515-kmod`, acompanhado do microcódigo `gpu-firmware-intel-kmod-alderlake` (que fornece os binários `adlp_dmc.bin`, `adlp_guc_70.bin` e `tgl_huc.bin`) e das bibliotecas de aceleração por hardware `multimedia/libva-intel-media-driver` (`iHD`) e `multimedia/libva-utils`.

#### B. Estabilidade de Wi-Fi Realtek (`rtw880` / LinuxKPI) & Avisos Benignos de TTY

- **Sintoma Crítico (Queda de Rede):** Queda da conexão com erros em cascata no console:
    ```text
    rtw880: lkpi_stop_hw_scan: failed to cancel scan: 35
    rtw880: failed to send h2c frame
    dhclient: send_packet: No buffer space available
    ```
- **Causa Raiz e Solução:** A varredura de roaming em segundo plano (_background scan_) do `rtw88` trava durante transições de autenticação (`AUTH`), enchendo o buffer de transmissão do driver e esgotando as filas do `dhclient`. Resolve-se desativando o roaming agressivo em background no `/etc/rc.conf` e configurando isolamento dinâmico via `devd` (`/usr/local/etc/devd/ethernet-wifi-isolation.conf`) para suspender a interface Wi-Fi quando o cabo Ethernet estiver ativo (`LINK_UP`), evitando disputa de locks na camada `LinuxKPI`:
    ```sh
    sysrc ifconfig_wlan0="WPA DHCP -bgscan powersave"
    ```
- **Falsos Positivos no TTY (`ttyv0`):** As mensagens `rtw880: lkpi_iv_newstate: error 95 during state transition 2 (AUTH) -> 2 (AUTH)` e `pulseaudio: Failed to load module "module-x11-xsmp"` frequentemente visíveis no console ao cair a sessão gráfica são apenas ruídos benignos (handshake WPA no `linuxkpi` e ausência de gerenciador de sessão X11 legado sob Wayland) e não têm relação com o `GPU HANG`.

#### C. Sanitização de Módulos de Kernel (`kld_list`)

- O `/etc/rc.conf` deve carregar módulos essenciais sem duplicatas (ex: evitar carregar `/boot/kernel/fusefs.ko` simultaneamente com `fusefs`).
- Ordem limpa de carregamento: `/boot/modules/i915kms.ko /boot/kernel/cuse.ko /boot/kernel/fusefs.ko /boot/kernel/ext2fs.ko vmm nmdm`.

---

### 10. Console Virtual (`vt`), Cursor Estático & Modo Monousuário

No FreeBSD, a gestão de consoles virtuais e telas de texto segue diretrizes estritas de estabilidade da base:

- **Driver `vt(4)` & Tipografia Spleen Dinâmica:** O driver `vt(4)` gerencia os terminais virtuais (`ttyv0` a `ttyv7`). A receita [`freebsd/desktop/system/system.sh`](../freebsd/desktop/system/system.sh) integra o serviço rc.d [`vt-autofont`](../freebsd/desktop/system/vt-autofont.sh) e configura a fonte proporcional no `/etc/rc.conf` via `allscreens_flags`: `spleen-8x16` em painéis $< 1080$p (HD 720p/768p), `spleen-12x24` em Full HD (1080p), `spleen-16x32` em 1440p/2K e `spleen-32x64` em 4K UHD ($\ge 2160$p, com opção de densidade `spleen-16x32` via `SPLEEN_DENSE=1`). Em configurações multi-monitor, o escalonador adota a maior resolução conectada para garantir legibilidade no painel de maior densidade. A recarga imediata em runtime sem reboot é executada via `service syscons restart`.
- **Navegação por Palavra (`Ctrl+Left` / `Ctrl+Right`) no Console `vt(4)`:** Por herança da emulação VT100/cons25, o driver `vt(4)` emite por padrão as setas normais (`^[[D` e `^[[C`) ao pressionar `Ctrl+Left` e `Ctrl+Right`. A remediação canônica no FreeBSD consiste em redefinir as teclas de função estendidas via `kbdcontrol -f 65 "\x1b[1;5D"` e `kbdcontrol -f 66 "\x1b[1;5C"`, garantindo avanço e recuo por palavra (`backward-word` / `forward-word`) idênticos ao terminal gráfico no Shell e Emacs.
- **OpenBSD (`wscons` & In-Kernel `rasops(9)` Scaling):** No OpenBSD, a família de fontes Spleen é mantida pelo próprio autor Frédéric Cambus (`fcambus@`, desenvolvedor OpenBSD). A seleção automática de glifos é implementada **diretamente no kernel** pelo subsistema raster `rasops(9)`: ao inicializar o framebuffer KMS (`inteldrm`, `amdgpu`, `efifb`), o kernel inspeciona nativamente a resolução física e escala automaticamente para `spleen-16x32` ($\ge 1920$px) ou `spleen-32x64` ($\ge 3840$px / 4K UHD), dispensando daemons de userspace. Inspeção e trocas manuais são executadas via `wsfontload(8)` e `wsconsctl display.font=...`.
- **Resolução Nativa Soberana (Sem Limite Artificial de GOP):** O ecossistema opera estritamente na maior resolução nativa suportada pelo painel (Full HD, 2K, 4K UHD) detectada dinamicamente pelo bootloader UEFI e mantida pelo driver KMS. Não utilizamos a diretiva de truncamento de resolução (`efi_max_resolution="1080p"` no `/boot/loader.conf`), pois a adequação ergonômica em telas HiDPI/4K é realizada diretamente na camada tipográfica (escalonando o glifo da fonte bitmap `spleen` para `16x32` ou `32x64`), preservando a fidelidade nativa do hardware.
- **Invariante do Cursor Estático no `vt(4)`:** O driver moderno `vt(4)` desenha o cursor como um bloco invertido estático diretamente no framebuffer (`sys/dev/vt/vt_core.c`). O kernel do FreeBSD não possui temporizador de pisque no `vt(4)`, tornando o cursor estático por concepção arquitetural. Parâmetros legados de cursor como `vidcontrol -c` pertenciam ao arcaico `sc(4)` dos anos 90 e são obsoletos/incompatíveis com `vt(4)` (rejeitados com erro de ioctl).
- **Silenciamento do Alerta Sonoro (`kern.vt.enable_bell=0`):** A campainha de sistema do console virtual `vt(4)` é desabilitada globalmente via `sysctl kern.vt.enable_bell=0` (persistido em `/etc/sysctl.conf`), eliminando bipes acústicos durante autocompletação ou limites de buffer.
- **Invariante do Modo Monousuário (_Single-User Mode_):** Ao inicializar em modo monousuário (`boot -s`), o kernel e o `/sbin/init` executam **incondicionalmente o `/bin/sh` estático da base**, ignorando shells configurados no `/etc/passwd` ou `shell_target`. O sistema de arquivos raiz (`/`) está montado em modo somente-leitura (`ro`), `/usr/local` não está montado e os subsistemas PAM e `login` não entram em execução, garantindo que o operador nunca sofra _lock out_.
