# 🖥️ Ambiente GNOME e a Camada do Host no Fedora

O ambiente gráfico é o componente visual que roda diretamente no _Host_ (conforme as diretrizes de [Filosofia](PHILOSOPHY.md)). No **Fedora Workstation**, adotamos o **GNOME Shell** puro com **Wayland** nativo por oferecer excelente estabilidade, aceleração de hardware out-of-the-box e ecossistema moderno voltado à produtividade.

---

## 🎯 Por que GNOME no Fedora?

1. **Wayland First:** O Fedora foi pioneiro na adoção do Wayland. O GNOME entrega uma sessão Wayland estável, com isolamento estrito entre janelas (evitando que aplicações leiam dados de outras) e renderização perfeita em monitores com escalonamento fracionário.
2. **Integração Adwaita / libadwaita Adaptativa:** Visual consistente em GTK3 e GTK4 com `adw-gtk3-theme` sincronizado dinamicamente com `color-scheme` (`adw-gtk3-dark` quando `prefer-dark`, `adw-gtk3` caso contrário), sem overrides estáticos de `GTK_THEME`.
3. **Consistência QT / GTK:** Para aplicações QT (como ferramentas do KDE Connect ou editores), configuramos `QT_QPA_PLATFORMTHEME=qt6ct` com o tema `plasma-breeze-qt6` para compatibilidade uniforme no GNOME.

---

## ⚙️ Configurações e Atalhos Automatizados

O script de provisionamento [`linux/desktop/fedora/desktop/gnome.sh`](../linux/desktop/fedora/desktop/gnome.sh) configura automaticamente via `gsettings`, `environment.d` e `systemctl --user`:

### 1. Janelas e Controles

- **Layout de Botões:** `:minimize,maximize,close` (reintroduz os botões de minimizar e maximizar mantendo o estilo limpo).
- **Desativação de Atalhos Conflitantes:** Desvincula atalhos padrão do GNOME que conflitam com IDEs ou fluxo de desenvolvimento (`show-desktop`, `minimize`, `maximize`).
- **Tema Adaptativo GTK3/Qt6:** Instala `adw-gtk3-theme`, ajusta `org.gnome.desktop.interface gtk-theme` conforme `color-scheme` ativo, remove o drop-in legado `gtk-dark.conf` e limpa `GTK_THEME`/`GTK_APPLICATION_PREFER_DARK_THEME` da sessão systemd do usuário.

### 2. Atalhos de Produtividade (Super Keys)

- `Super + C`: Calculadora
- `Super + S`: Configurações do Sistema (GNOME Control Center)
- `Super + W`: Navegador Web
- `Super + H`: Pasta Pessoal (Home Folder)

---

## 🔗 Integração com o Universal Shell

O repositório **[Shell](https://github.com/GabrielFrigo4/shell)** atua em sinergia com o GNOME:

1. **Ponte Visual GTK ⟷ Qt6:** O ambiente mantém `QT_QPA_PLATFORMTHEME=qt6ct` via `environment.d/qt.conf` enquanto permite que GTK3/GTK4 respondam nativamente à troca dinâmica claro/escuro do portal XDG Desktop e `gsettings`.
2. **Wayland & Electron:** Configura `ELECTRON_OZONE_PLATFORM_HINT="auto"` e `_JAVA_AWT_WM_NONREPARENTING=1` para garantir escalonamento nítido e responsivo em editores gráficos como Antigravity, VS Code e IDEs JetBrains.
3. **Dispositivos Móveis (`~/Device`):** As funções de terminal `mount-device` e `umount-device` integram-se com o GVFS e com a extensão **GSConnect** (implementação GNOME do KDE Connect), permitindo acessar o celular Android diretamente no terminal em `~/Device` ou via Nautilus.

---

## 🚀 Como Executar

Para aplicar ou reconfigurar o ambiente GNOME no Fedora:

```sh
sh linux/desktop/fedora/desktop/gnome.sh
```

Ou copie e cole os blocos de comandos diretamente no terminal caso esteja consultando pelo GitHub.
