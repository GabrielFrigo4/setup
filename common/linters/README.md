# 🛠️ Common Linters & Formatters Setup

> Receitas universais em POSIX Shell para instalação das ferramentas CLI de formatação e análise estática.

---

## 🎯 Finalidade

Esta pasta instala os binários CLI globais de formatação e linting (**Prettier**, **Ruff** e **Mermaid CLI / `mermaid-filter`**). As configurações declarativas de formatadores (`.prettierrc`, `.clang-format`, `.stylua.toml`, `ruff.toml`) são sincronizadas pelo repositório **Profile**.

---

## 📂 Catálogo de Arquivos

| Arquivo                      | Plataforma                    | Descrição                                                                                                       |
| :--------------------------- | :---------------------------- | :-------------------------------------------------------------------------------------------------------------- |
| [`prettier.sh`](prettier.sh) | Linux / FreeBSD / macOS / WSL | Instala o runtime Node.js/NPM e o binário global do Prettier CLI                                                |
| [`mermaid.sh`](mermaid.sh)   | Linux / FreeBSD / macOS / WSL | Instala o runtime Node.js/NPM, `mermaid-filter` (para Pandoc) e o CLI global `@mermaid-js/mermaid-cli` (`mmdc`) |
| [`ruff.sh`](ruff.sh)         | Linux / FreeBSD / Windows     | Instala o linter e formatador de código Python Ruff CLI nativo                                                  |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/linters/prettier.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/linters/mermaid.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/linters/ruff.sh"
```
