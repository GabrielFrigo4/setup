# 🪟 Windows — Ferramentas Nativas & Subsistema MSYS2

> Diretório raiz de provisionamento para o sistema operacional Windows, organizado por ambiente de execução.

---

## 🎯 Finalidade

Reúne o ferramental de provisionamento para Windows, dividido em dois ambientes essenciais:

- **`native/`**: Ferramentas nativas do Windows (gerenciadores de pacotes Winget/Scoop/Choco, suite de engenharia reversa, editores, temas e módulos).
- **`msys2/`**: Subsistema UNIX nativo UCRT64 (toolchains GCC, Clang/LLVM, linguagens e bibliotecas sem virtualização).

> ℹ️ **Ambiente WSL2:** Como o WSL2 executa um kernel Linux real, as receitas para distribuições WSL residem em [`../linux/wsl/`](../linux/wsl/README.md).

---

## 📂 Contextos Operacionais

| Contexto                          | Tipo                | Descrição                                                                     |
| :-------------------------------- | :------------------ | :---------------------------------------------------------------------------- |
| **[`native/`](native/README.md)** | Ferramentas Nativas | Pacotes via Winget/Scoop, suite de engenharia reversa, temas e módulos        |
| **[`msys2/`](msys2/README.md)**   | Subsistema UCRT64   | 7 receitas temáticas de compilação GNU/LLVM, linguagens e bibliotecas nativas |

---

## 🚀 Como Navegar

Para acessar as ferramentas nativas de desenvolvimento e segurança no Windows, acesse [`native/`](native/README.md).
