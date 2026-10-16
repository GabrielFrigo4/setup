# 🛠️ Common Linters & Formatters Setup

> Receitas universais em POSIX Shell para implantação de configurações globais de formatadores de código e LSP a partir da fonte da verdade (`software/tools/`).

---

## 🎯 Finalidade

Esta pasta fornece scripts de provisionamento para implantar as configurações globais de formatadores e linters no diretório de configuração do usuário (**Clangd**, **Clang-Format**, **Prettier**, **StyLua** e **Ruff**), sincronizando diretamente dos dotfiles estáticos do repositório [Profile](https://github.com/GabrielFrigo4/profile/tree/main/tools).

> ℹ️ **Automações Windows (CMD):** A receita equivalente para Windows reside em [`../../windows/native/linters/linters.cmd`](../../windows/native/linters/linters.cmd).

---

## 📂 Catálogo de Arquivos

| Arquivo                      | Plataforma                    | Descrição                                                                                                       |
| :--------------------------- | :---------------------------- | :-------------------------------------------------------------------------------------------------------------- |
| [`linters.sh`](linters.sh)   | Linux / FreeBSD / macOS / WSL | Implanta `.clang-format`, `.prettierrc`, `.stylua.toml`, `ruff.toml`, `config.yaml` do Clangd e configs Mermaid |
| [`prettier.sh`](prettier.sh) | Linux / FreeBSD / macOS / WSL | Instala o runtime Node.js/NPM e o binário global do Prettier CLI                                                |
| [`mermaid.sh`](mermaid.sh)   | Linux / FreeBSD / macOS / WSL | Instala o runtime Node.js/NPM, `mermaid-filter` (para Pandoc) e o CLI global `@mermaid-js/mermaid-cli` (`mmdc`) |
| [`ruff.sh`](ruff.sh)         | Linux / FreeBSD / Windows     | Instala o linter e formatador de código Python Ruff CLI nativo                                                  |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

### 1. Implantar Dotfiles de Linters & Formatadores:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/linters.sh | sh
```

### 2. Instalar Prettier CLI Global:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/prettier.sh | sh
```

### 3. Instalar Mermaid CLI & Filter Global:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/mermaid.sh | sh
```

### 4. Instalar Ruff CLI Global:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/linters/ruff.sh | sh
```
