# 📄 Office Suites — Catálogo de Produtividade Multiplataforma

> Receitas modulares e idempotentes para provisionamento de suites de produtividade e documentos de escritório em Linux, FreeBSD e Windows.

---

## 🎯 Finalidade

Esta pasta centraliza as rotinas de instalação e configuração de suites de escritório modernas:

1. **LibreOffice:** A suíte completa nativa de produtividade com suporte integral a temas escuros GTK3/GTK4 e persistência de sessão.
2. **Collabora Office Desktop:** A implementação focada em compatibilidade de documentos e privacidade construída sobre o motor Collabora Online / LibreOffice.

---

## 📂 Catálogo de Recursos

| Recurso                            | Tipo    | Plataformas Alvo               | Método de Provisionamento                                                      |
| :--------------------------------- | :------ | :----------------------------- | :----------------------------------------------------------------------------- |
| **[`office.sh`](office.sh)**       | Receita | Linux, FreeBSD                 | Dispatch universal (`dnf` / `apt` / `pacman` / `pkg`) com patch de tema escuro |
| **[`collabora.sh`](collabora.sh)** | Receita | Linux, FreeBSD, Windows (MSYS) | Dispatch universal (`pkg` / `dnf` / `apt` / `pacman` / Flatpak / Winget)       |

---

## 🛠️ Detalhes da Receita `office.sh` (LibreOffice Suite)

A receita `office.sh` executa o provisionamento completo e padronização visual da suíte:

### 1. Suíte Completa de Módulos

Garante a instalação dos 6 aplicativos oficiais da suíte:

- **Writer:** Processador de texto e documentação.
- **Calc:** Planilhas eletrônicas e análise estatística.
- **Impress:** Apresentações e slides multimídia.
- **Draw:** Diagramas de fluxo, vetores e manipulação gráfica.
- **Math:** Editor de equações matemáticas e notação científica.
- **Base:** Gerenciamento de bancos de dados relacionais e formulários.

Junto aos módulos da aplicação, a receita instala os backends VCL `libreoffice-gtk3` e `libreoffice-gtk4`.

### 2. Injeção de Tema Escuro nos Lançadores `.desktop`

Para evitar o problema comum de aplicativos do LibreOffice abrirem com fundo branco desarmonioso em desktops escuros, o script copia os lançadores do sistema para `~/.local/share/applications/` e injeta na linha de execução `Exec=`:

```ini
Exec=env SAL_USE_VCLPLUGIN=gtk3 GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1 libreoffice
```

Caso o tema `adw-gtk3-dark` não esteja instalado no sistema, o script aplica automaticamente fallback para `Adwaita:dark`.

### 3. Persistência de Sessão (`environment.d`)

Cria o drop-in `~/.config/environment.d/gtk-dark.conf` contendo:

```ini
GTK_THEME=adw-gtk3-dark
GTK_APPLICATION_PREFER_DARK_THEME=1
SAL_USE_VCLPLUGIN=gtk3
```

Exporta imediatamente os parâmetros para o systemd e barramento D-Bus do usuário via `systemctl --user set-environment` e `dbus-update-activation-environment`.

### 4. Overrides para Flatpak

Configura regras globais para o runtime do Flatpak:

```sh
flatpak override --user --env=GTK_THEME=Adwaita:dark
```

### 5. Sinergia com Editores (`common/editors/editors.sh`)

Em conjunto com `office.sh`, o script `editors.sh` padroniza o lançador do GNU Emacs gerando um ícone consolidado `emacs.desktop` com tema GTK3 escuro (`emacsclient --create-frame --alternate-editor="" %F`) e oculta lançadores secundários redundantes (`emacsclient.desktop`, `emacs-mail.desktop`, `emacsclient-mail.desktop`) via `NoDisplay=true`.

---

## 🌐 Suporte por Plataforma (Collabora Office)

### 🐧 Linux

- **Flathub (Universal):** Aplicação empacotada oficialmente sob o ID `com.collaboraoffice.Office`.
- **Arch Linux (AUR):** Binário mantido pela comunidade através do pacote `collabora-office-bin`.

### 🪟 Windows

- **Microsoft Store / Winget:** Distribuído oficialmente via Microsoft Store com o Product ID `9P9MRBXJJG0M` (`Collabora Office Desktop`).
- **Comando Equivalente:**
    ```cmd
    winget install 9P9MRBXJJG0M --accept-package-agreements --accept-source-agreements
    ```

### 😈 FreeBSD

- **Status Upstream:** Port oficial e suporte nativo em andamento pela comunidade e engenharia Collabora.
- **Auto-cura e Resiliência:** O script verifica proativamente a disponibilidade de `collabora-office` no repositório `pkg`. Assim que o port for publicado no catálogo oficial, o provisionamento ocorrerá sem necessidade de refatoração.

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Executar o provisionamento do LibreOffice completo:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/office/office.sh | sh
```

Executar o provisionamento do Collabora Office:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/office/collabora.sh | sh
```
