# 💼 bootstrap/common/workspace/ — Provisionamento do Ecossistema

Esta pasta contém a receita atômica de bootstrapping para inicializar e clonar todo o **Quarteto de Produtividade** em uma estação de trabalho nova ou limpa.

---

## 📄 Receitas

- **`workspace.sh`**:
  - Cria o diretório de trabalho `${HOME}/Documentos/Environment` (ou o caminho passado por argumento).
  - Gera o **Makefile** global de orquestração multirepo na raiz do ambiente.
  - Clona os 4 repositórios federados (`Setup`, `Shell`, `Vault`, `Profile`) em uma única invocação.

---

## 🚀 Execução Rápida via GitHub (Zero-Clone)

Em qualquer computador novo com `git` e `curl` instalados:

```sh
curl -fsSL "https://raw.githubusercontent.com/GabrielFrigo4/setup/main/bootstrap/common/workspace/workspace.sh" | sh
```

Após o término, acesse o diretório e opere via `make`:

```sh
cd ~/Documentos/Environment
make status
make sync
```
