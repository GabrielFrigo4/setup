# 🖥️ FreeBSD Desktop (KDE Plasma) — Catálogo de Receitas

> Receitas atômicas, portáteis e idempotentes para provisionar a estação de trabalho FreeBSD Desktop.

---

## 🎯 Finalidade

Esta pasta reúne scripts portáteis para a estação de trabalho gráfica FreeBSD, cobrindo ambiente KDE Plasma 6 Wayland, serviços base (`vt_autofont`, `sndiod`, `dbus`, `seatd`, `ntpd`), dispositivos, rede e ports. Quirks específicos de máquinas físicas residem em [`../../hosts/`](../../hosts/README.md).

> ℹ️ **Infraestrutura Base & CLI:** Receitas de elevação de privilégios (`doas.conf`), parâmetros portáteis de kernel e utilitários universais de terminal residem em [`../common/`](../common/README.md).

---

## 📂 Catálogo Categorizado

| Categoria        | Receita                                                                    | Descrição                                                                                                           |
| :--------------- | :------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------ |
| **`system/`**    | [`system/system.sh`](system/system.sh)                                     | Configuração base portátil: grupos, `vt_autofont`, `moused`, `dbus`, `seatd`, `ntpd`, `sndiod`, `syslogd_flags=-ss` |
| **`system/`**    | [`system/vt-autofont.sh`](system/vt-autofont.sh)                           | Serviço rc.d `vt_autofont` para escalonamento dinâmico de fontes Spleen conforme resolução                          |
| **`system/`**    | [`system/toolchain.sh`](system/toolchain.sh)                               | Toolchain GNU: `gcc` e `coreutils`                                                                                  |
| **`system/`**    | [`system/ttys.sh`](system/ttys.sh)                                         | Alinhamento canônico, auto-cura e formatação tabular do `/etc/ttys`                                                 |
| **`system/`**    | [`system/zfs-arc.sh`](system/zfs-arc.sh)                                   | Dimensionamento dinâmico de memória ZFS ARC (4/16), Host (11/16) e Bhyve VM (1/16)                                  |
| **`gui/`**       | [`gui/kde.sh`](gui/kde.sh)                                                 | Ambiente gráfico KDE Plasma 6 Wayland, tema GTK (`plasma6-breeze-gtk`) e portais XDG                                |
| **`gui/`**       | [`gui/ly.sh`](gui/ly.sh)                                                   | Gerenciador de login TUI Ly (`gettytab`, `ttys`, tema 8-cores compatível com `vt(4)` e rotação `newsyslog`)         |
| **`ports/`**     | [`ports/ports.sh`](ports/ports.sh)                                         | Clonagem e sincronização da árvore oficial de Ports via Git                                                         |
| **`devices/`**   | [`devices/webcam.sh`](devices/webcam.sh)                                   | Serviço `webcamd` para webcams USB                                                                                  |
| **`devices/`**   | [`devices/filesystem.sh`](devices/filesystem.sh)                           | Drivers FUSE para exFAT, NTFS e EXT2/3/4                                                                            |
| **`network/`**   | [`network/wifi.sh`](network/wifi.sh)                                       | Configuração de rede sem fio com `wpa_supplicant` e autodetecção via `net.wlan.devices`                             |
| **`network/`**   | [`network/wifibox.sh`](network/wifibox.sh)                                 | Máquina virtual Bhyve com drivers Wi-Fi Linux (Wifibox)                                                             |
| **`emulation/`** | [`emulation/compat.sh`](emulation/compat.sh)                               | Camada de compatibilidade Linux no kernel (`linux_enable="YES"`)                                                    |
| **`emulation/`** | [`emulation/wine.sh`](emulation/wine.sh)                                   | Wine e Winetricks para execução de binários Windows                                                                 |
| **`security/`**  | [`../../common/security/wireshark.sh`](../../common/security/wireshark.sh) | Wireshark com permissão BPF (`/dev/bpf*`) no devfs para captura sem root                                            |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/setup.sh" --profile=freebsd-desktop
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/desktop/gui/kde.sh"
```
