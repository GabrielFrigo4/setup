# 🤖 Inteligência Artificial Local (Ollama, llama.cpp & Vulkan)

> Guia de instalação, compilação e configuração do ecossistema de IA local com aceleração de hardware via Vulkan nas 3 plataformas do ecossistema (FreeBSD, Linux e Windows).

---

## 📦 Pré-Requisitos: Stack Vulkan

Antes de instalar o Ollama ou compilar o llama.cpp com aceleração de GPU, é necessário ter a stack Vulkan completa instalada no sistema.

### FreeBSD

```sh
pkg install vulkan-loader vulkan-headers vulkan-tools shaderc
```

### Linux (Fedora)

```sh
sudo dnf install vulkan-loader-devel vulkan-headers vulkan-tools shaderc
```

### Linux (Arch)

```sh
sudo pacman -S vulkan-icd-loader vulkan-headers vulkan-tools shaderc
```

### Linux (Debian / Ubuntu)

```sh
sudo apt install libvulkan-dev vulkan-tools glslang-tools
```

### Windows (MSYS2 UCRT64)

```sh
pacman -S mingw-w64-ucrt-x86_64-vulkan-loader mingw-w64-ucrt-x86_64-vulkan-headers mingw-w64-ucrt-x86_64-shaderc
```

### Verificação

Após instalar, valide a stack com:

```sh
vulkaninfo --summary
```

Deve exibir informações do driver Vulkan da GPU (Mesa, NVIDIA, AMD AMDVLK, etc.).

---

## 🦙 Ollama — Servidor de Inferência Local

O [Ollama](https://ollama.com) é o servidor de inferência local que expõe uma API HTTP compatível com OpenAI em `http://127.0.0.1:11434`. Permite executar modelos de linguagem (LLMs) diretamente na GPU local sem depender de serviços cloud.

### Instalação por Plataforma

#### FreeBSD

```sh
pkg install ollama
```

#### Linux

```sh
curl -fsSL https://ollama.com/install.sh | sh
```

#### Windows

Baixe o instalador oficial em [ollama.com/download](https://ollama.com/download/windows) e execute normalmente. O Ollama é instalado como serviço do Windows e expõe a mesma API em `localhost:11434`.

### Configuração de Serviço (FreeBSD)

```sh
sudo sysrc ollama_enable="YES"
sudo sysrc ollama_user="gabrielf"
sudo sysrc ollama_use_vulkan="1"

sudo service ollama start
```

### Configuração de Serviço (Linux — systemd)

```sh
sudo systemctl enable --now ollama
```

### Verificação

```sh
ollama --version
curl -s http://localhost:11434/api/tags | head
```

### Modelos Recomendados (2025/2026)

| Modelo                | Parâmetros | Uso Principal                      | Comando                           |
| :-------------------- | :--------: | :--------------------------------- | :-------------------------------- |
| `gemma4:e2b`          |     2B     | Chat leve e rápido                 | `ollama pull gemma4:e2b`          |
| `gemma4:e4b`          |     4B     | Chat balanceado                    | `ollama pull gemma4:e4b`          |
| `qwen3.5`             |   7-14B    | Raciocínio e código                | `ollama pull qwen3.5`             |
| `phi4`                |    14B     | Raciocínio compacto (Microsoft)    | `ollama pull phi4`                |
| `deepseek-r1:distill` |   7-14B    | Raciocínio profundo (cadeia longa) | `ollama pull deepseek-r1:distill` |

---

## 🔨 llama.cpp — Compilação com Vulkan

O [llama.cpp](https://github.com/ggml-org/llama.cpp) é a engine de inferência de referência para modelos GGUF. A compilação com backend Vulkan permite execução acelerada em GPUs de qualquer fabricante (AMD, Intel, NVIDIA) sem dependência de CUDA.

### Compilação Manual (CMake)

```sh
git clone https://github.com/ggml-org/llama.cpp.git
cd llama.cpp
cmake -B build -DGGML_VULKAN=ON
cmake --build build --config Release
```

O binário resultante estará em `build/bin/llama-cli`.

### Compilação via Ports (FreeBSD)

```sh
cd /usr/ports/misc/llama-cpp && make -DWITH_VULKAN install clean
```

Ou via `pkg` se o pacote já estiver disponível:

```sh
pkg install llama-cpp
```

### Verificação

```sh
./build/bin/llama-cli --version
# Deve exibir: Vulkan backend enabled
```

---

## 🔗 Integração com Editores

Após o Ollama estar rodando em `localhost:11434`:

| Editor     | Pacote/Plugin | Configuração                                               |
| :--------- | :------------ | :--------------------------------------------------------- |
| **Emacs**  | `gptel`       | Backend Ollama auto-detectado via `ollama-detect-p`        |
| **Emacs**  | `ellama`      | Provider OpenAI-compatible apontado para `localhost:11434` |
| **NeoVim** | `avante.nvim` | Configurar endpoint Ollama no setup do plugin              |
| **NeoVim** | `ollama.nvim` | Plugin dedicado para interação direta                      |

> **Nota:** A configuração do `gptel` no Emacs detecta automaticamente se o Ollama está rodando e registra o backend condicionalmente. Se o serviço não estiver ativo, o Emacs inicia normalmente com Gemini como backend padrão.

---

## 🌐 Interfaces Web Locais

Para conversas com histórico persistente em banco de dados local:

| Interface      | Tecnologia    | Armazenamento | Comando de Início                                               |
| :------------- | :------------ | :------------ | :-------------------------------------------------------------- |
| **Open-WebUI** | Docker/Podman | SQLite local  | `podman run -d -p 3000:8080 ghcr.io/open-webui/open-webui:main` |

> **Nota:** O Open-WebUI se conecta automaticamente ao Ollama em `localhost:11434` e grava todas as conversas em um banco SQLite no disco local.
