# 🌐 Bootstrap Common (Multiplataforma POSIX) — Catálogo de Receitas

> Receitas modulares e universais em POSIX Shell (`.sh`) compartilhadas entre Linux, FreeBSD, macOS, WSL2 e MSYS2.

---

## 🎯 Finalidade

Esta pasta abriga receitas de automação que são **100% puras em POSIX Shell (`.sh`)**, agnósticas de distribuição e prontas para execução imediata em qualquer ambiente UNIX.

> ℹ️ **Automações Windows (.cmd / .ps1):** As receitas equivalentes para Windows residem em [`../windows/native/`](../windows/native/README.md).

---

## 📂 Catálogo de Recursos

| Recurso                                      | Tipo        | Descrição                                                                                                                        |
| :------------------------------------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------- |
| **[`system/nopass.sh`](system/nopass.sh)**   | Receita     | Elevação de privilégios (`doas` + `sudo`) **sem senha** (0440)                                                                   |
| **[`system/persist.sh`](system/persist.sh)** | Receita     | Elevação de privilégios (`doas` + `sudo`) **com senha e sessão de 5 minutos** (0440)                                             |
| **[`system/strict.sh`](system/strict.sh)**   | Receita     | Elevação de privilégios (`doas` + `sudo`) **estrita (senha sempre / zero cache)** (0440)                                         |
| **[`editors/`](editors/README.md)**          | Subcatálogo | Perfis pessoais (`editors.sh`), frameworks (`doom-emacs.sh`, `lazyvim.sh`, `spacevim.sh`) e sincronizador (`sync-extensions.sh`) |
| **[`fonts/`](fonts/README.md)**              | Receita     | Instalação de fontes tipográficas essenciais (`JetBrainsMono`, `RobotoMono`, `MesloLGS NF`)                                      |
| **[`linters/`](linters/README.md)**          | Receitas    | Implantação de formatadores (`linters.sh`) e instalador global do Prettier (`prettier.sh`)                                       |
| **[`vcs/`](vcs/README.md)**                  | Receitas    | Configuração global do Git (`git.sh`) e Game of Trees (`got.sh`)                                                                 |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Execute qualquer receita diretamente via terminal:

```sh
# Configurar privilégios sem senha (Desktop)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/system/nopass.sh | sh

# Configurar privilégios com sessão salva (Servidor / VPS)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/system/persist.sh | sh

# Configurar privilégios com senha sempre (Servidor Crítico / Estrito)
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/system/strict.sh | sh

# Instalar fontes universais
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/fonts/fonts.sh | sh

# Configurar formatadores e linters globais
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/linters/linters.sh | sh

# Configurar Git
curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/bootstrap/common/vcs/git.sh | sh
```
