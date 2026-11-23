# 🤖 Common AI & Local Inference Tools

> Receitas universais em POSIX Shell para instalação do servidor de inferência Ollama e SDK Python.

---

## 🎯 Finalidade

Esta pasta centraliza o provisionamento do servidor de inferência local **Ollama** e seu respectivo SDK Python, viabilizando a execução de LLMs locais diretamente via GPU/CPU com aceleração Vulkan.

---

## 📂 Catálogo de Arquivos

| Arquivo / Receita        | Descrição                                                   | Plataforma                                  |
| :----------------------- | :---------------------------------------------------------- | :------------------------------------------ |
| [`ollama.sh`](ollama.sh) | Servidor de inferência local Ollama e biblioteca Python SDK | Linux / FreeBSD / macOS / WSL / MSYS2 / Win |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/ai/ollama.sh"
```
