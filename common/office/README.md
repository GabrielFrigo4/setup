# 📄 Office Suites — Catálogo de Produtividade Multiplataforma

> Receitas modulares e idempotentes para provisionamento de suites de produtividade e documentos de escritório em Linux, FreeBSD e Windows.

---

## 🎯 Finalidade

Esta pasta centraliza as rotinas de instalação e configuração de suites de escritório modernas:

1. **LibreOffice:** A suíte completa nativa de produtividade com backend GTK3 adaptativo ao tema claro/escuro do desktop.
2. **Collabora Office Desktop:** A implementação focada em compatibilidade de documentos e privacidade construída sobre o motor Collabora Online / LibreOffice.

---

## 📂 Catálogo de Recursos

| Recurso                            | Tipo    | Plataformas Alvo               | Método de Provisionamento                                                            |
| :--------------------------------- | :------ | :----------------------------- | :----------------------------------------------------------------------------------- |
| **[`office.sh`](office.sh)**       | Receita | Linux, FreeBSD, Windows (MSYS) | Dispatch universal (`pkg` / `dnf` / `apt` / `pacman` / `Winget`) com integração GTK3 |
| **[`collabora.sh`](collabora.sh)** | Receita | Linux, FreeBSD, Windows (MSYS) | Dispatch universal (`pkg` / `dnf` / `apt` / `pacman` / Flatpak / Winget)             |

---

## 🛠️ Detalhes da Receita `office.sh` (LibreOffice Suite)

A receita `office.sh` executa o provisionamento completo e padronização visual adaptativa da suíte:

### 1. Suíte Completa de Módulos

Garante a instalação dos 6 aplicativos oficiais da suíte:

- **Writer:** Processador de texto e documentação.
- **Calc:** Planilhas eletrônicas e análise estatística.
- **Impress:** Apresentações e slides multimídia.
- **Draw:** Diagramas de fluxo, vetores e manipulação gráfica.
- **Math:** Editor de equações matemáticas e notação científica.
- **Base:** Gerenciamento de bancos de dados relacionais e formulários.

Junto aos módulos da aplicação, a receita instala os backends VCL `libreoffice-gtk3` e `libreoffice-gtk4`.

### 2. Backend GTK3 Adaptativo nos Lançadores `.desktop`

Para garantir integração nativa ao esquema claro/escuro ativo do ambiente de desktop sem forçar tema fixo, o script copia os lançadores do sistema para `~/.local/share/applications/` e aplica apenas o backend VCL GTK3 na linha `Exec=`:

```ini
Exec=env SAL_USE_VCLPLUGIN=gtk3 libreoffice
```

### 3. Limpeza de Overrides Legados de Sessão (`environment.d`)

Remove o drop-in legado `~/.config/environment.d/gtk-dark.conf` caso exista e limpa variáveis forçadas (`GTK_THEME` e `GTK_APPLICATION_PREFER_DARK_THEME`) em `systemctl --user`, permitindo que aplicativos sigam dinamicamente a preferência do desktop.

### 4. Temas Adaptativos para Flatpak

Remove qualquer override global legado de `GTK_THEME` (`flatpak override --user --unset-env=GTK_THEME` e nível de sistema) e garante a instalação dos pacotes de tema `org.gtk.Gtk3theme.adw-gtk3` e `org.gtk.Gtk3theme.adw-gtk3-dark` no Flathub (quando o remote existir) para que aplicativos em sandbox sigam o tema claro/escuro ativo da sessão.

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

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/office/office.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/office/collabora.sh"
```
