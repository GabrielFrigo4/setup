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

### 9. Estabilidade de Hardware, Kernel & Aceleração Gráfica

Em estações de trabalho móveis e desktops com processadores Intel Core de 12ª Geração (Alder Lake-UP3 GT2 / Intel Iris Xe Graphics) e adaptadores Wi-Fi Realtek sob FreeBSD, a interação entre o driver gráfico `i915kms`, a camada de compatibilidade `LinuxKPI` e o subsistema de memória virtual (`vm`) exige atenção detalhada à arquitetura de versões e parâmetros de inicialização.

#### A. Diagnóstico Profundo de GPU Hang no Intel Alder Lake / Iris Xe (FreeBSD 15.1 vs 15.2)

1. **A Causa Raiz da Regressão:**
   No FreeBSD 15.0-RELEASE, o meta-pacote `graphics/drm-kmod` instalava o **`drm-66-kmod`** (baseado no kernel Linux 6.6 LTS), que operava com a versão 3 do mapeamento GTT (`i915_gem_mmap_gtt_version = 3`). No FreeBSD 15.1-RELEASE, o pacote padrão foi alterado para o **`drm-612-kmod`** (baseado no Linux 6.12 LTS), o qual redefiniu `i915_gem_mmap_gtt_version` para o valor **5**, ativando a interface moderna `I915_GEM_MMAP_OFFSET` (especificamente mapeamentos _Write-Back_ `I915_MMAP_OFFSET_WB`).

2. **Perda de Propriedade de Páginas `shmem` no LinuxKPI:**
   A GPU Intel Iris Xe não possui memória VRAM dedicada, compartilhando a memória física RAM do sistema via objetos GEM alocados como objetos VM de memória compartilhada (`shmem`). Na camada `LinuxKPI` do FreeBSD (`sys/compat/linuxkpi/common/src/linux_page.c`), a função `lkpi_vmf_insert_pfn_prot_locked()` desassocia a página física (`vm_page_t`) de seu objeto `shmem` de origem através de `vm_page_remove(page)` e a vincula ao objeto do paginador de dispositivos (`device_pager` / `cdev_pager`) para mapeamento no espaço de usuário.

3. **Engatilhamento sob Pressão de RAM e Paginação de Swap:**
   Quando múltiplas aplicações gráficas concorrem por RAM física, o _shrinker_ do `i915` (`i915_gem_drop_caches` / `DROP_UNBOUND`) é acionado para desalocar buffers inativos, revogando as PTEs do `device_pager`, enquanto o paginador do FreeBSD inicia o envio de páginas `shmem` para a partição de swap. Como a propriedade da página não é devolvida ao objeto `shmem` original antes da liberação, a releitura da área resulta em perda irreversível de integridade de dados (`RESULT=DATA_LOSS`). Caso dois mapeamentos paralelos tentem referenciar a mesma página em GTT v5, `lkpi_vmf_insert_pfn_prot_locked()` rejeita a chamada com `page rename failed: page is mapped`, retornando `VM_FAULT_NOPAGE` e aprisionando `linux_cdev_pager_populate()` em loops contínuos de falta de página.

4. **Sintomas no Kernel e Queda do Compositor:**
   Ao tentar recuperar texturas ou instruções de páginas corrompidas ou paginadas incorretamente, o motor 3D/Compute da GPU (`rcs0`) para de responder. O _watchdog_ do kernel registra o estouro do tempo limite de preempção:

    ```text
    drmn0: [drm] GPU HANG: ecode 12:1:85dffffb, in kwin_wayland [101380]
    drmn0: [drm] Resetting rcs0 for preemption time out
    drmn0: [drm] kwin_wayland[101380] context reset due to GPU hang
    drmn0: [drm] GPU HANG: ecode 12:1:859ffffb, in QSGRenderThread [101660]
    drmn0: [drm] Resetting rcs0 for preemption time out
    drmn0: [drm] Fence expiration time out i915-drmn0
    ```

    Após o reset de contexto, o compositor Wayland (`kwin_wayland`) perde o contexto EGL (`EGL_CONTEXT_LOST`), e as chamadas subsequentes de _DRM Atomic KMS_ falham por timeout (`Pageflip timed out!` / `atomic commit failed`), inviabilizando a restauração da sessão gráfica.

5. **Bug Booleano de `cancel_delayed_work_sync()` e Escalonador GuC:**
   No FreeBSD 15.1, a implementação de `linux_cancel_delayed_work_sync()` na camada `LinuxKPI` retornava `false` ao remover com sucesso uma tarefa pendente na fila (ao passo que o Linux retorna `true`). O escalonador de microcódigo GuC do driver `i915` utiliza este valor de retorno para decidir sobre a liberação imediata (_unpin_) de contextos. A divergência de valor invertido provocava o estado de falha `GT0: GUC: Bad context sched_state 0x6`. Além disso, a execução de interrupções via `ithread` preemptível no LinuxKPI permitia que a GPU entrasse no estado de economia de energia RC6 antes da leitura dos registradores de interrupção. O parâmetro `compat.linuxkpi.i915_enable_guc="2"` mantém o escalonamento sob a CPU e carrega exclusivamente o microcódigo **HuC** para aceleração de vídeo, mitigando a corrupção do GuC.

6. **Comportamento da Alternância de Console (`Ctrl+Alt+F3`):**
    - **Console Acessível (`Ctrl+Alt+F3` Funcional):** Quando o reset do motor `rcs0` conclui e apenas os contextos gráficos das aplicações do usuário são anulados, o motor de display 2D permanece ativo, permitindo acesso ao console `vt(4)` em `ttyv2`.
    - **Sistema Inoperante (`Ctrl+Alt+F3` Travado):** Caso a falha ocorra durante o travamento de locks no loop de repetição de `linux_cdev_pager_populate()` ou o subsistema DRM declare o hardware irrecuperável (`declaring wedged!`), os descritores e mutexes do console ficam retidos no kernel, exigindo o reinício forçado da máquina.

---

#### B. Matriz Comparativa de Versões e Status DRM

| Versão / Ramo do FreeBSD                                  | Driver DRM                                 | Pacote Firmware Intel Alder Lake | Suíte Mesa            | Status Operacional para Intel Iris Xe (Alder Lake)                                                                                          |
| :-------------------------------------------------------- | :----------------------------------------- | :------------------------------- | :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| **FreeBSD 15.0-RELEASE** (EoL 30/09/2026)                 | `drm-66-kmod 6.6.25`                       | `20250109`                       | Série `25.x` / `26.0` | **Estável:** Opera em GTT v3, sem perda de páginas `shmem` ou anomalias de Vulkan.                                                          |
| **FreeBSD 15.1-RELEASE (`quarterly`)**                    | `drm-612-kmod 6.12.85.1501000_2`           | `20260519.1501000`               | `26.2.2`              | **Crítico / Instável:** Falhas de Vulkan, preempção em `rcs0` e perda de páginas `shmem` sob swap.                                          |
| **FreeBSD 15.1-RELEASE (`latest`)**                       | `drm-612-kmod 6.12.110.1501000_3`          | `20260519.1501000`               | `26.2.2_1`            | **Melhorado:** Corrige Vulkan (commit `3e1c3ad47598`), reduz travamentos (PR 295625), mas vulnerável a `shmem` sob swap.                    |
| **FreeBSD 15.2-BETA1 / `stable/15`** (Release 08/12/2026) | `drm-612-kmod 6.12.110_3` / `drm-66-kmod`  | `20260519`                       | `26.2.2_1`            | **Kernel Atualizado:** OpenZFS `2.4.4`, `PR #2268` (GuC `0x6`), `D58194` e `D58195`, aguardando merge do patch `shmem` (`D59481`/`D59883`). |
| **FreeBSD 16.0-CURRENT (`main`)**                         | `drm-612-kmod` / `drm_v6.13` / `drm_v6.14` | `20260519`                       | `26.2.2_1` / `devel`  | **Experimental:** Transição estrutural de `struct page` (`D58320`/`D58498`), sujeita a panics de _unwiring_.                                |

---

#### C. Estratégia Canônica: Downgrade Seletivo para `drm-66-kmod` e Blindagem

Para restabelecer estabilidade imediata e determinística no FreeBSD 15.1-RELEASE sem abrir mão do KDE Plasma 6 e dos softwares atualizados, a solução canônica do ecossistema consiste em aplicar o downgrade seletivo para o pacote **`drm-66-kmod`** e travar a versão com `pkg lock`:

1. **Criação de Boot Environment Preventivo no ZFS:**

    ```sh
    bectl create pre-drm66-fix
    ```

2. **Substituição Atômica e Travamento de Pacotes:**

    ```sh
    pkg delete -f -y drm-kmod drm-612-kmod
    pkg install -y drm-66-kmod gpu-firmware-intel-kmod-alderlake multimedia/libva-intel-media-driver multimedia/libva-utils
    pkg lock -y drm-66-kmod
    ```

3. **Garantia de Carregamento Tardo do Driver no `/etc/rc.conf`:**
   O módulo `i915kms.ko` não deve ser carregado prematuramente no `/boot/loader.conf` (onde reside na `module_blacklist`), mas sim através da infraestrutura de inicialização de serviços:

    ```sh
    sysrc kld_list+="i915kms"
    ```

4. **Parametrização Consolidada no `/boot/loader.conf`:**
   Valores de tunables com pontos não devem ser aplicados via `sysrc`, exigindo inserção direta no arquivo de configuração do bootloader:

    ```ini
    compat.linuxkpi.i915_enable_guc="2"
    compat.linuxkpi.i915_enable_psr="0"
    compat.linuxkpi.i915_enable_psr2_sel_fetch="0"
    compat.linuxkpi.i915_enable_fbc="0"
    compat.linuxkpi.i915_enable_dc="0"
    compat.linuxkpi.i915_disable_power_well="0"
    kern.ipc.shmseg="1024"
    kern.ipc.shmmni="1024"
    kern.maxproc="100000"
    vfs.zfs.arc.max="4294967296"
    vfs.zfs.arc.min="1073741824"
    vfs.zfs.txg.timeout="10"
    ```

5. **Proporção Canônica de Memória de 16 Partes (Host 16 GB):**
    - **1/16 VM Bhyve / NetBSD:** 1 GB reservado para convidados virtuais sob demanda (piso 1 GB, teto 2 GB).
    - **4/16 ZFS ARC:** 4 GB fixados no ARC (`vfs.zfs.arc.max="4294967296"`), preservando memória contra saturação.
    - **11/16 Host & DRM:** ~11 GB disponíveis exclusivamente para o KDE Plasma 6, navegadores, compilações e buffers GEM da GPU integrada.

6. **Runbook de Verificação e Auditoria Pós-Reboot:**
    ```sh
    sysctl vfs.zfs.arc.max vfs.zfs.arc.min kern.maxfiles kern.ipc.shmmax
    sysctl compat.linuxkpi.i915_enable_psr compat.linuxkpi.i915_enable_psr2_sel_fetch compat.linuxkpi.i915_enable_fbc compat.linuxkpi.i915_enable_dc compat.linuxkpi.i915_enable_guc
    dmesg | grep -iE "drmn0|guc|huc"
    sudo vm list
    vainfo
    ```

---

#### D. Estabilidade de Wi-Fi Realtek (`rtw880` / LinuxKPI) & Avisos de Console

- **Prevenção de Esgotamento de Buffers de Transmissão:** A varredura contínua de redes em background (_background scan_) do driver `rtw88` acarreta congestionamento na fila durante mudanças de estado `AUTH`, culminando no erro `dhclient: send_packet: No buffer space available`. Desativa-se o roaming em background no `/etc/rc.conf`:
    ```sh
    sysrc ifconfig_wlan0="WPA DHCP -bgscan powersave"
    ```
- **Isolamento Dinâmico de Interfaces Ethernet e Wi-Fi:** O daemon `devd` desativa a interface de rádio `wlan0` no evento `LINK_UP` do cabo Ethernet (`re0`) e a reativa no evento `LINK_DOWN`, eliminando contenção de recursos na camada `LinuxKPI`.
- **Avisos Não-Críticos no Console Virtual:** Entradas como `rtw880: lkpi_iv_newstate: error 95 during state transition` e `pulseaudio: Failed to load module "module-x11-xsmp"` refletem mensagens informativas do handshake WPA e da ausência de sessão X11 sob compositores Wayland nativos, não guardando correlação com falhas de GPU.

#### E. Sanitização da Lista de Módulos de Kernel (`kld_list`)

A declaração no `/etc/rc.conf` segue a hierarquia determinística de carregamento:

```text
/boot/modules/i915kms.ko /boot/kernel/cuse.ko /boot/kernel/fusefs.ko /boot/kernel/ext2fs.ko vmm nmdm
```

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
