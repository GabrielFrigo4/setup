# 🏗️ Arquitetura do Bootstrap & Livro de Receitas (Cookbook)

Este documento descreve a filosofia, a estrutura modular e a padronização das receitas de provisionamento no repositório **Configuration**.

---

## 🎯 Filosofia: O Modelo "Cookbook"

O `Configuration` adota o modelo de **Livro de Receitas (Cookbook)**:

1. **Zero Dependência de Clone:** Diferente do `Vault` ou do `Shell`, o usuário **não precisa clonar** este repositório para utilizá-lo. Ele é consumido diretamente via **GitHub**:
    - Navegando e copiando/colando trechos específicos;
    - Baixando arquivos declarativos puros (`.json`, `.toml`, `.yaml`);
    - Executando receitas isoladas pontualmente via terminal.
2. **Modularidade Radical (Sem Monólitos):** Nenhum script deve tentar instalar 50 ferramentas diferentes de uma só vez. Cada receita é atômica, autoexplicativa e executa uma única função com excelência.
3. **Clean Host:** Compiladores de projeto, bancos de dados e runtimes pesados pertencem a containers (Docker, Incus, FreeBSD Jails). O host só recebe os drivers, a interface gráfica (GNOME no Fedora, KDE no FreeBSD) e ferramentas essenciais de análise/sistema.

---

## 📐 Template Canônico de Receitas (`RECIPE TEMPLATE`)

Para garantir uniformidade e previsibilidade, todo script de configuração segue rigorosamente esta estrutura com a resolução atômica de `ELEVATE`:

```sh
#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: [Nome do Software / Funcionalidade]
# ----------------------------------------------------------------
set -eu

echo "📦 [Nome]: Iniciando configuração..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

echo "✅ [Nome]: Configurado com sucesso!"
```

### 🔍 Mecânica da Resolução de Elevação (`ELEVATE`)
- **Isolamento via Subshell:** A expressão `$( ... )` avalia o ambiente sem vazar variáveis auxiliares ou poluir o escopo do script.
- **Detecção Imediata de Root:** Se `id -u` for `0` (`root`), a primeira cláusula encerra em curto-circuito e `ELEVATE` torna-se `""`.
- **Precedência POSIX com Chaves (`{ ...; }`):** Evita que o fallback para `sudo` seja executado indevidamente caso `doas` esteja presente (ambos os operadores `&&` e `||` têm a mesma precedência em POSIX).
- **Detecção Silenciosa:** Utiliza `command -v` com redirecionamento citado `> "/dev/null" 2>&1`.
- **Soberania do Usuário:** Prioriza `doas` sobre `sudo`, mas degrada para execução sem privilégios caso nenhum esteja instalado.

---

## 📂 Organização das Receitas por Categorias

As receitas dentro de `bootstrap/` são categorizadas por funcionalidade:

- **`system/`**: Configurações essenciais de usuário, privilégios (`doas`, `sudo`), kernel e sysctl.
- **`desktop/`**: Ambientes de interface gráfica (GNOME no Fedora, KDE Plasma no FreeBSD) e fontes.
- **`containers/`**: Virtualização leve de sistema (Docker, Incus, FreeBSD Bastille Jails).
- **`security/`**: Ferramentas de análise, engenharia reversa e captura de pacotes (Wireshark com BPF, Ghidra, Horsicq suite).
- **`emulation/`**: Camadas de compatibilidade (Linuxlator no FreeBSD, Wine/Winetricks).
- **`devices/`**: Roteamento de áudio/microfone para Android via RTP, webcams e drivers FUSE.
- **`network/`**: Configurações de Wi-Fi nativo e Wifibox (drivers Wi-Fi Linux no FreeBSD).
- **`tools/`**: Utilitários modernos de terminal (eza, bat, ripgrep, mandoc) e IDEs (Antigravity).
- **`apps/`**: Aplicativos desktop focados (leitor de ePub Arianna, navegadores TUI).

---

## 📜 Regras de Manutenção

1. **Nomenclatura:** Todos os scripts de receita devem adotar letras minúsculas com hífens (`kebab-case`). Exemplo: `wireshark.sh`, `reverse-engineering.cmd`.
2. **Shebang Obrigatório:** `#!/usr/bin/env sh` em 100% dos scripts de shell UNIX.
3. **Permissões em 4 Dígitos:** Use sempre `chmod 0755` para scripts/pastas, `chmod 0644` para arquivos de configuração e `chmod 0440` para autorizações do sistema (`doas.conf`, `sudoers.d/*`).
