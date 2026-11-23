# 🖥️ Windows Native Languages — Python 3.14 & Runtimes

> Receitas modulares de automação para provisionamento de runtimes de linguagens e dependências Python no Windows nativo.

---

## 🎯 Finalidade

Esta pasta reúne scripts dedicados para instalação e sincronização de runtimes de programação e suas bibliotecas essenciais no ambiente Windows nativo, integrando Winget (`Python.Python.3.14`, `astral-sh.uv`) e `pip`.

---

## 📂 Catálogo de Recursos

| Recurso                        | Tipo    | Método de Instalação             | Identificador / Pacotes                                                                                                                        |
| :----------------------------- | :------ | :------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| **[`python.cmd`](python.cmd)** | Receita | Winget + `pip install --upgrade` | `Python.Python.3.14`, `astral-sh.uv`, `PyQt6`, `rich`, `textual`, `opencv-python-headless`, `numpy`, `Pillow`, `python-docx`, `tqdm`, `ollama` |

---

## 🚀 Como Executar

Abra o Prompt de Comando (`cmd.exe`) ou PowerShell e execute:

```cmd
python.cmd
```
