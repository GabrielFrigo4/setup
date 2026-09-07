# 🖥️ Ambiente KDE (Plasma) e a Camada do Host no FreeBSD

A interface gráfica é o componente mais pesado que tem a permissão de rodar diretamente no _Host_ (conforme as diretrizes de [Filosofia](PHILOSOPHY.md)). No **FreeBSD Desktop**, adotamos o **KDE Plasma 6** com **Wayland** nativo por oferecer a melhor integração com hardware, customização absoluta e aceleração gráfica no ecossistema BSD.

---

## 🎯 Por que KDE no FreeBSD?

No nosso ecossistema dual (**Fedora com GNOME** e **FreeBSD com KDE Plasma**), o KDE é o ambiente de escolha para a estação de trabalho FreeBSD por entregar:

1. **Wayland Nativo:** Sessão Wayland pura iniciada via `startplasma-wayland`, isolando processos gráficos sem a insegurança do X11 legado.
2. **Desempenho Direto no Host:** Aceleração de hardware (GPU) sem overhead, proporcionando fluidez para gerenciar Bastille Jails, bhyve e volumes ZFS.
3. **Konsole Moderno:** O emulador de terminal nativo do KDE oferece excelente renderização, perfis unificados para shells (`software/terminals/konsole/`) e suporte integral ao ecossistema [Shell](https://github.com/GabrielFrigo4/Shell).

---

## 🔒 Polkit: Gerenciamento de Privilégios no FreeBSD

Como limitamos ao máximo o uso de comandos administrativos diretos no host gráfico, o **Polkit** gerencia elevações de privilégios:

- **Caminho do Agente no FreeBSD:**
    ```text
    /usr/local/libexec/polkit-kde-authentication-agent-1
    ```
    _(Diferente do Linux, onde fica em `/usr/lib/...`, no FreeBSD softwares de terceiros residem estritamente em `/usr/local/`)_.
- **pkexec:** Para rodar aplicações gráficas de manutenção de disco ou partições com segurança, utilize `pkexec` para invocar a janela de autorização nativa do KDE.

---

## 🔗 Integração com o Universal Shell

O repositório **[Shell](https://github.com/GabrielFrigo4/Shell)** traz integrações nativas para o KDE:

1. **Detecção e Tema Unificado:** Detecta o tema escuro via `kreadconfig6` e exporta automaticamente `QT_STYLE_OVERRIDE=Breeze-Dark` e `GTK_THEME=Breeze-Dark`, mantendo coerência absoluta entre apps Qt e GTK.
2. **Dispositivos Móveis (`~/Device`):** As funções de terminal `mount-device` e `umount-device` utilizam o **KDE Connect** (`kdeconnect-cli --mount`) e KIO-Fuse, permitindo acessar o celular Android diretamente em `~/Device` ou via Dolphin.
3. **Atalhos do Terminal:** Comandos dedicados como `way` (atalho para `ck-launch-session dbus-run-session startplasma-wayland`).

---

## 🚀 Como Executar

Para instalar e configurar o ambiente KDE Plasma no FreeBSD:

```sh
sh bootstrap/freebsd/desktop/gui/kde.sh
```
