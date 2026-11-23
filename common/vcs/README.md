# 🌿 Version Control Systems (Git, Got & Git-Crypt)

> Receitas universais em POSIX Shell para instalação de ferramentas de controle de versão e criptografia de repositórios.

---

## 🎯 Finalidade

Esta pasta centraliza a instalação multiplataforma de clientes e ferramentas de controle de versão (`git`, `gh`, `git-lfs`, `got`) e criptografia transparente (`git-crypt`).

---

## 📂 Catálogo de Arquivos

| Arquivo                        | Plataforma                            | Descrição                                               |
| :----------------------------- | :------------------------------------ | :------------------------------------------------------ |
| [`tools.sh`](tools.sh)         | Linux / FreeBSD / macOS / WSL / MSYS2 | Instalação de Git, GitHub CLI (`gh`), `git-lfs` e `got` |
| [`git-crypt.sh`](git-crypt.sh) | Linux / FreeBSD / macOS / Windows     | Instalação multiplataforma da ferramenta `git-crypt`    |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/vcs/tools.sh"
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/common/vcs/git-crypt.sh"
```
