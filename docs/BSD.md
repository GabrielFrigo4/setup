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

Para executar código que exige um kernel Linux ou para virtualizar outras instâncias, tiramos proveito do **bhyve**, o hypervisor nativo do FreeBSD. Em conjunto com ZVOLs (discos virtuais baseados em ZFS), criamos máquinas virtuais de altíssima performance para complementar nosso ambiente _Clean Host_. Veja a documentação de [Hypervisors](HYPERVISORS.md).

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

- **Sintoma:** Congelamento total da sessão Wayland (`kwin_wayland`) ou reinício forçado com erro no kernel:
    ```text
    drmn0: [drm] Resetting rcs0 for preemption time out
    drmn0: [drm] GPU HANG: ecode 12:1:85dffffb, in Renderer [101727]
    drmn0: [drm] Resetting chip for stopped heartbeat on rcs0
    ```
- **Causa Raiz:** O motor de renderização `rcs0` não atinge o timeout de preempção ao alternar estados profundos de economia de energia (_Display C-States_) e compressão de frame (_Panel Self Refresh_ e _Frame Buffer Compression_) sob o driver `i915kms`.
- **Solução Definitiva:** Adicionar os parâmetros no `/boot/loader.conf`:
    ```ini
    compat.linuxkpi.i915_enable_psr="0"
    compat.linuxkpi.i915_enable_fbc="0"
    compat.linuxkpi.i915_enable_dc="0"
    ```
- **Tratamento de Sintaxe (`sysrc` vs `/boot/loader.conf`):** O comando `sysrc` rejeita nomes de variáveis contendo pontos (`.`) como `compat.linuxkpi.*`. Por isso, a receita de provisionamento [`system.sh`](../freebsd/desktop/system/system.sh) implementa a função `_set_loader_tunable` com manipulação idempotente direta.
- **Drivers de Kernel:** Garantir o uso do pacote moderno `drm-61-kmod` (baseado no Linux 6.1) em vez do legado `drm-515-kmod`, acompanhado do microcódigo `gpu-firmware-intel-kmod-alderlake`.

#### B. Estabilidade de Wi-Fi Realtek (`rtw880` / LinuxKPI)

- **Sintoma:** Queda da conexão com erros em cascata no console:
    ```text
    rtw880: lkpi_stop_hw_scan: failed to cancel scan: 35
    rtw880: failed to send h2c frame
    dhclient: send_packet: No buffer space available
    ```
- **Causa Raiz:** A varredura de roaming em segundo plano (_background scan_) do `rtw88` trava durante transições de autenticação (`AUTH`), enchendo o buffer de transmissão do driver e esgotando as filas do `dhclient`.
- **Solução:** Desativar o roaming agressivo em background no `/etc/rc.conf`:
    ```sh
    sysrc ifconfig_wlan0="WPA DHCP -bgscan"
    ```

#### C. Sanitização de Módulos de Kernel (`kld_list`)

- O `/etc/rc.conf` deve carregar módulos essenciais sem duplicatas (ex: evitar carregar `/boot/kernel/fusefs.ko` simultaneamente com `fusefs`).
- Ordem limpa de carregamento: `/boot/modules/i915kms.ko /boot/kernel/cuse.ko /boot/kernel/fusefs.ko /boot/kernel/ext2fs.ko vmm nmdm`.
