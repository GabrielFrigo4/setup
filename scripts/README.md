# 🛠️ Scripts Utilitários

> Ferramentas de compilação, conversores de arquivos, auditorias de qualidade e manipulação de registro.

---

## 🎯 Finalidade

Esta pasta contém utilitários de suporte focados em automações de compilação local (build), conversões de arquivos, análise estática de código e modificações no registro do Windows.

> ℹ️ **Scripts Interativos de Terminal:** Aliases, prompts e funções interativas pertencem ao repositório **[Shell](https://github.com/GabrielFrigo4/Shell)**.

---

## 📂 Catálogo de Categorias

| Categoria                                 | Tipo               | Descrição                                                                               |
| :---------------------------------------- | :----------------- | :-------------------------------------------------------------------------------------- |
| **[`audit/`](audit/README.md)**           | Análise Estática   | Auditores de código (`monoliths.py` e `nanos.py`) para manter o equilíbrio arquitetural |
| **[`build/`](build/README.md)**           | Compilação         | Compilação a partir do código-fonte (Aseprite e LibreSprite)                            |
| **[`convert/`](convert/README.md)**       | Conversores        | Conversão unificada de quebras de linha (`line-endings`) e Markdown para PDF (`md2pdf`) |
| **[`windows/`](windows/README.md)**       | Sistema & Registro | Injeções seguras de registro (`.reg`) para UTF-8, AltGr, Emacs e Hyper-V                |

---

## 📜 Princípios e Padrões Obrigatórios

Conforme os princípios estabelecidos em [`../PRINCIPLES.md`](../PRINCIPLES.md):

1. **Shebang Padrão Absoluto (`#!/usr/bin/env sh` / `#!/usr/bin/env python3`):** Todo script de shell deve utilizar `#!/usr/bin/env sh`.
2. **Permissões em 4 Dígitos Octais:** Utilize sempre `chmod 0755` para scripts executáveis e `chmod 0644` para arquivos estáticos (`.reg`, documentação).
3. **Regra da Composição:** Scripts de conversão e utilitários devem suportar encadeamento com ferramentas padrão Unix via pipes (`|`) e saídas previsíveis.
4. **Programação Defensiva (`set -eu`):** Todo script deve ativar `set -eu` para falhar ruidosamente caso ocorram erros ou variáveis inexistentes.
