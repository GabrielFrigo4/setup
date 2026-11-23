# 🧠 Universal Setup Core Modules

> Biblioteca de fundação em POSIX Shell para detecção de sistema, elevação antifrágil, abstração de pacotes, auto-cura de permissões e emissão semântica de interface.

---

## 🎯 Finalidade

O diretório `core/` contém os módulos internos carregados pelas receitas do **Setup**, por [`bootstrap.sh`](../bootstrap.sh) e pelo orquestrador [`setup.sh`](../setup.sh). Nenhum arquivo aqui instala pacotes diretamente ao ser carregado; eles fornecem a infraestrutura de execução para todas as receitas do repositório.

---

## 📂 Catálogo de Módulos

| Arquivo                    | Descrição                                                                                   |
| :------------------------- | :------------------------------------------------------------------------------------------ |
| [`detect.sh`](detect.sh)   | Detecta SO (`DETECTED_OS`), distribuição (`DETECTED_DISTRO`), pacote e fonte de console     |
| [`elevate.sh`](elevate.sh) | Resolve o binário de elevação administrativa respeitando a precedência `doas > sudo`        |
| [`pkg.sh`](pkg.sh)         | Abstração universal de pacotes (`_pkg_update`, `_pkg_install`) consumindo `core/detect.sh`  |
| [`perms.sh`](perms.sh)     | Auto-cura cirúrgica de permissões POSIX (`0755` para scripts/hooks/auditores, `0644` docs)  |
| [`ui.sh`](ui.sh)           | Emissão semântica ANSI (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`) |
