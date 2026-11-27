# 🖥️ Ambiente KDE (Plasma) e a Camada do Host no FreeBSD

A interface gráfica é o componente mais pesado que tem a permissão de rodar diretamente no _Host_ (conforme as diretrizes de [Filosofia](PHILOSOPHY.md)). No **FreeBSD Desktop**, adotamos o **KDE Plasma 6** com **Wayland** nativo por oferecer a melhor integração com hardware, customização absoluta e aceleração gráfica no ecossistema BSD.

---

## 🎯 Por que KDE no FreeBSD?

No nosso ecossistema dual (**Fedora com GNOME** e **FreeBSD com KDE Plasma**), o KDE é o ambiente de escolha para a estação de trabalho FreeBSD por entregar:

1. **Wayland Nativo:** Sessão Wayland pura iniciada via `startplasma-wayland`, isolando processos gráficos sem a insegurança do X11 legado.
2. **Desempenho Direto no Host:** Aceleração de hardware (GPU) sem overhead, proporcionando fluidez para gerenciar Bastille Jails, bhyve e volumes ZFS.
3. **Konsole Moderno:** O emulador de terminal nativo do KDE oferece excelente renderização, perfis unificados para shells (`Profile/terminals/konsole/`) e suporte integral ao ecossistema [Shell](https://github.com/GabrielFrigo4/shell).

---

## 🔒 Polkit: Gerenciamento de Privilégios no FreeBSD

Como limitamos ao máximo o uso de comandos administrativos diretos no host gráfico, o **Polkit** gerencia elevações de privilégios:

- **Caminho do Agente no FreeBSD:**
    ```text
    /usr/local/lib/libexec/polkit-kde-authentication-agent-1
    ```
    _(Diferente do Linux, onde fica em `/usr/lib/...` ou `/usr/libexec/...`, no FreeBSD o KDE Plasma 6 instala o agente sob `/usr/local/lib/libexec/`)_.
- **pkexec:** Para rodar aplicações gráficas de manutenção de disco ou partições com segurança, utilize `pkexec` para invocar a janela de autorização nativa do KDE.

---

## 🔗 Integração com o Universal Shell

O repositório **[Shell](https://github.com/GabrielFrigo4/shell)** traz integrações nativas para o KDE:

1. **Detecção e Tema Unificado:** Detecta dinamicamente o esquema de cores (`dark`/`light`) via `kreadconfig6` / portal XDG; em sessões Full DE preserva a gestão nativa do Plasma sem pinning estático, e em sessões standalone exporta `QT_STYLE_OVERRIDE="Breeze"` (estilo QStyle válido no Qt6) junto ao tema GTK correspondente (`Breeze-Dark` ou `Breeze`), mantendo coerência visual entre apps Qt e GTK.
2. **Dispositivos Móveis (`~/Device`):** As funções de terminal `mount-device` e `umount-device` utilizam o **KDE Connect** (`kdeconnect-cli --mount`) e KIO-Fuse, permitindo acessar o celular Android diretamente em `~/Device` ou via Dolphin.
3. **Atalhos do Terminal:** Comandos dedicados como `way` (atalho para `ck-launch-session dbus-run-session startplasma-wayland`).

---

## 🚀 Como Executar

Para instalar e configurar o ambiente KDE Plasma 6 e o gerenciador de login Ly no FreeBSD (a receita `gui/kde.sh` também aplica override XDG `Hidden=true` em `DiscoverNotifier` para evitar consumo contínuo de CPU pelo `packagekitd`, pareando com `gui/ly.sh` em `ttyv1`):

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/desktop/gui/kde.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/freebsd/desktop/gui/ly.sh"
```
