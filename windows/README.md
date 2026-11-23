# 🪟 Windows — Ferramentas Nativas & Subsistema MSYS2

> Diretório raiz de provisionamento para o sistema operacional Windows, organizado por ambiente de execução.

---

## 🎯 Finalidade

Reúne o ferramental de provisionamento para Windows, dividido em dois ambientes essenciais:

- **`native/`**: Pacotes declarativos via Winget (`winget.json`) e Scoop idempotente, engenharia reversa, atalhos PowerShell, Hyper-V e registro do Windows.
- **`msys2/`**: Subsistema UNIX nativo UCRT64 (7 receitas temáticas padronizadas com `core/ui.sh`).

> ℹ️ **Ambiente WSL2:** Como o WSL2 executa um kernel Linux real, as receitas para distribuições WSL residem em [`../linux/wsl/`](../linux/wsl/README.md).

---

## 📂 Contextos Operacionais

| Contexto                          | Tipo                | Descrição                                                                           |
| :-------------------------------- | :------------------ | :---------------------------------------------------------------------------------- |
| **[`native/`](native/README.md)** | Ferramentas Nativas | Manifesto `winget.json`, Scoop, engenharia reversa, registro, Hyper-V e `setup.ps1` |
| **[`msys2/`](msys2/README.md)**   | Subsistema UCRT64   | 7 receitas temáticas de compilação GNU/LLVM, linguagens e bibliotecas nativas       |

---

## 🚀 Como Navegar

Para acessar as ferramentas nativas de desenvolvimento, pacotes e segurança no Windows, acesse [`native/`](native/README.md).
