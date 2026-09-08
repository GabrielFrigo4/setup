# 🖥️ FreeBSD Desktop (KDE Plasma) — Catálogo de Receitas

> Receitas atômicas, modulares e idempotentes para provisionar a estação de trabalho FreeBSD Desktop.

---

## 🎯 Finalidade

Esta pasta reúne scripts especializados para a estação de trabalho gráfica FreeBSD, cobrindo ambiente KDE Plasma 6 Wayland, aceleração de dispositivos, áudio, rede, emulação e ports.

> ℹ️ **Infraestrutura Base & CLI:** Receitas de elevação de privilégios (`doas.conf`), parâmetros de kernel e utilitários universais de terminal residem em [`../common/`](../common/README.md).

---

## 📂 Catálogo Categorizado

| Categoria        | Receita                                              | Descrição                                                                               |
| :--------------- | :--------------------------------------------------- | :-------------------------------------------------------------------------------------- |
| **`system/`**    | [`system/system.sh`](system/system.sh)               | Grupos essenciais (`wheel`, `video`, `webcamd`), fontes Spleen e diretório de workspace |
| **`gui/`**       | [`gui/kde.sh`](gui/kde.sh)                           | Ambiente gráfico KDE Plasma 6 Wayland, clipboard e `desktop-installer`                  |
| **`ports/`**     | [`ports/ports.sh`](ports/ports.sh)                   | Clonagem e sincronização da árvore oficial de Ports via Git                             |
| **`devices/`**   | [`devices/audio.sh`](devices/audio.sh)               | Roteamento de áudio do sistema para celular Android via USB/RTP                         |
| **`devices/`**   | [`devices/microphone.sh`](devices/microphone.sh)     | Recepção de áudio do microfone do celular via RTP na porta 5005                         |
| **`devices/`**   | [`devices/webcam.sh`](devices/webcam.sh)             | Serviço `webcamd` para webcams USB                                                      |
| **`devices/`**   | [`devices/filesystem.sh`](devices/filesystem.sh)     | Drivers FUSE para exFAT, NTFS e EXT2/3/4                                                |
| **`network/`**   | [`network/wifi.sh`](network/wifi.sh)                 | Configuração nativa de rede sem fio com `wpa_supplicant`                                |
| **`network/`**   | [`network/wifibox.sh`](network/wifibox.sh)           | Máquina virtual Bhyve com drivers Wi-Fi Linux (Wifibox)                                 |
| **`emulation/`** | [`emulation/linuxlator.sh`](emulation/linuxlator.sh) | Camada de compatibilidade Linux no kernel (`linux_enable="YES"`)                        |
| **`emulation/`** | [`emulation/wine.sh`](emulation/wine.sh)             | Wine e Winetricks para execução de binários Windows                                     |
| **`security/`**  | [`security/wireshark.sh`](security/wireshark.sh)     | Wireshark com permissão BPF (`/dev/bpf*`) no devfs para captura sem root                |
| **`apps/`**      | [`apps/epub.sh`](apps/epub.sh)                       | Leitor de ePub Arianna (KDE) e navegadores TUI (`w3m`, `lynx`)                          |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita individualmente copiando o link RAW diretamente para o terminal do FreeBSD:

```sh
fetch -o - https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/freebsd/desktop/gui/kde.sh | sh
```
