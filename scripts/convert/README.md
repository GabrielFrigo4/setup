# 🔄 Convert (Conversores & Processamento de Arquivos)

> Scripts utilitários para conversão de quebras de linha (CRLF ⟷ LF) e geração em lote de PDFs a partir de Markdown.

---

## 🎯 Finalidade

Esta pasta centraliza ferramentas para sanear e converter formatos de arquivos entre diferentes sistemas operacionais:

- **`line-endings`:** Conversão unificada de quebras de linha (`\r\n` ⟷ `\n`) sem depender de pacotes externos.
- **`md2pdf`:** Conversão recursiva em lote de diretórios Markdown para PDFs tipograficamente elegantes via Pandoc e WeasyPrint.

---

## 📂 Catálogo de Arquivos

| Arquivo                                | Tipo               | Descrição                                                                 |
| :------------------------------------- | :----------------- | :------------------------------------------------------------------------ |
| [`line-endings.sh`](line-endings.sh)   | Script Shell POSIX | Converte recursivamente finais de linha entre LF (UNIX) e CRLF (DOS)      |
| [`line-endings.ps1`](line-endings.ps1) | PowerShell         | Versão PowerShell para conversão de finais de linha no Windows            |
| [`md2pdf.sh`](md2pdf.sh)               | Script Shell POSIX | Percorre pastas e converte arquivos `.md` em `.pdf` preservando estrutura |
| [`md2pdf.ps1`](md2pdf.ps1)             | PowerShell         | Versão PowerShell do conversor Markdown para PDF                          |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

### Conversão de Quebras de Linha

```sh
# Converter para LF (UNIX)
sh scripts/convert/line-endings.sh --to-unix

# Converter para CRLF (Windows)
sh scripts/convert/line-endings.sh --to-dos
```

### Markdown para PDF

```sh
# Converte todos os arquivos .md dentro da pasta docs/:
sh scripts/convert/md2pdf.sh ./docs
```
