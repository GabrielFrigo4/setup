# 🛠️ Scripts Utilitários

> Ferramentas de compilação local e auditoria estática de qualidade e diagnóstico.

---

## 🎯 Finalidade

Esta pasta contém utilitários internos de suporte focados em automações de compilação a partir do código-fonte (`build/`) e análise estática + diagnóstico de saúde do sistema (`audit/`).

> ℹ️ **Scripts Interativos de Terminal:** Aliases, prompts e funções interativas pertencem ao repositório **[Shell](https://github.com/GabrielFrigo4/shell)**.

---

## 📂 Catálogo de Categorias

| Categoria                       | Tipo             | Descrição                                                             |
| :------------------------------ | :--------------- | :-------------------------------------------------------------------- |
| **[`audit/`](audit/README.md)** | Análise Estática | Auditores estáticos (`all.py`, 9 módulos) e diagnóstico (`doctor.sh`) |
| **[`build/`](build/README.md)** | Compilação       | Compilação a partir do código-fonte (Aseprite e LibreSprite)          |

---

## 📜 Princípios e Padrões Obrigatórios

Conforme os princípios estabelecidos em [`../PRINCIPLES.md`](../PRINCIPLES.md):

1. **Shebang Padrão Absoluto (`#!/usr/bin/env sh` / `#!/usr/bin/env python3`):** Todo script de shell deve utilizar `#!/usr/bin/env sh`.
2. **Permissões em 4 Dígitos Octais:** Utilize sempre `chmod 0755` para scripts executáveis e `chmod 0644` para documentações.
3. **Programação Defensiva (`set -eu`):** Todo script deve ativar `set -eu` para falhar ruidosamente caso ocorram erros ou variáveis inexistentes.
