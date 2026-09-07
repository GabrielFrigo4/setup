# 🖥️ Ambiente GNOME e a Camada do Host no Fedora

O ambiente gráfico é o componente visual que roda diretamente no _Host_ (conforme as diretrizes de [Filosofia](PHILOSOPHY.md)). No **Fedora Workstation**, adotamos o **GNOME Shell** puro com **Wayland** nativo por oferecer excelente estabilidade, aceleração de hardware out-of-the-box e ecossistema moderno voltado à produtividade.

---

## 🎯 Por que GNOME no Fedora?

1. **Wayland First:** O Fedora foi pioneiro na adoção do Wayland. O GNOME entrega uma sessão Wayland estável, com isolamento estrito entre janelas (evitando que aplicações leiam dados de outras) e renderização perfeita em monitores com escalonamento fracionário.
2. **Integração Adwaita / libadwaita:** Visual consistente e moderno com tema escuro uniforme (`adw-gtk3-dark`).
3. **Consistência QT / GTK:** Para aplicações QT (como ferramentas do KDE Connect ou editores), configuramos `QT_QPA_PLATFORMTHEME=qt6ct` com o tema `plasma-breeze-qt6` para que aplicações QT se integrem organicamente com o tema escuro do GNOME.

---

## ⚙️ Configurações e Atalhos Automatizados

O script de provisionamento [`bootstrap/linux/desktop/fedora/desktop/gnome.sh`](../bootstrap/linux/desktop/fedora/desktop/gnome.sh) configura automaticamente via `gsettings`:

### 1. Janelas e Controles

- **Layout de Botões:** `:minimize,maximize,close` (reintroduz os botões de minimizar e maximizar mantendo o estilo limpo).
- **Desativação de Atalhos Conflitantes:** Desvincula atalhos padrão do GNOME que conflitam com IDEs ou fluxo de desenvolvimento (`show-desktop`, `minimize`, `maximize`).

### 2. Atalhos de Produtividade (Super Keys)

- `Super + C`: Calculadora
- `Super + S`: Configurações do Sistema (GNOME Control Center)
- `Super + W`: Navegador Web
- `Super + H`: Pasta Pessoal (Home Folder)

---

## 🔗 Integração com o Universal Shell

O repositório **[Shell](https://github.com/GabrielFrigo4/Shell)** atua em profunda sinergia com o GNOME:

1. **Ponte Visual GTK ⟷ Qt6:** O Shell detecta o ambiente GNOME em tempo de execução via `detect_desktop_environment` e injeta automaticamente `QT_QPA_PLATFORMTHEME=qt6ct` e `GTK_THEME=adw-gtk3-dark`, assegurando que aplicativos Qt e GTK rodem com o mesmo tema escuro sem falhas visuais.
2. **Wayland & Electron:** Configura `ELECTRON_OZONE_PLATFORM_HINT="auto"` e `_JAVA_AWT_WM_NONREPARENTING=1` para garantir escalonamento nítido e responsivo em editores gráficos como Antigravity, VS Code e IDEs JetBrains.
3. **Dispositivos Móveis (`~/Device`):** As funções de terminal `mount-device` e `umount-device` integram-se com o GVFS e com a extensão **GSConnect** (implementação GNOME do KDE Connect), permitindo acessar o celular Android diretamente no terminal em `~/Device` ou via Nautilus.

---

## 🚀 Como Executar

Para aplicar ou reconfigurar o ambiente GNOME no Fedora:

```sh
sh bootstrap/linux/desktop/fedora/desktop/gnome.sh
```

Ou copie e cole os blocos de comandos diretamente no terminal caso esteja consultando pelo GitHub.
