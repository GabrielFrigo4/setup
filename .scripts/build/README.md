# 🔨 Build Scripts (Compilação a partir do Fonte)

> Scripts de compilação automatizada para softwares de arte digital a partir do código-fonte original.

---

## 🎯 Finalidade

Permite compilar localmente ferramentas de pixel art e animação (Aseprite e LibreSprite) integrando backends modernos (Skia) e ferramentas de build (CMake, Ninja e Clang):

- **Aseprite:** Compilação da versão de desenvolvimento com backend gráfico Skia m102 via ferramentas MSVC.
- **LibreSprite:** Compilação do fork livre do Aseprite tanto para Linux quanto para Windows.

---

## 📂 Catálogo de Arquivos

| Arquivo                              | Tipo               | Plataforma  | Descrição                                                             |
| :----------------------------------- | :----------------- | :---------- | :-------------------------------------------------------------------- |
| [`aseprite.cmd`](aseprite.cmd)       | Script Batch CMD   | Windows     | Baixa Skia m102 pré-compilado, clona o repo e compila via Ninja/CMake |
| [`libresprite.cmd`](libresprite.cmd) | Script Batch CMD   | Windows     | Script de build automatizado do LibreSprite para Windows              |
| [`libresprite.sh`](libresprite.sh)   | Script Shell POSIX | Linux / BSD | Script de build com dependências nativas para sistemas UNIX           |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

No Windows, abra o terminal do **Visual Studio Developer Command Prompt** (`VsDevEnv x64`) e execute os comandos descritos em [`aseprite.cmd`](aseprite.cmd) para gerar o binário em sua máquina.
