# 🗺️ Roadmap & Backlog

> Planejamento estratégico, status operacional e visão de futuro para a evolução do **Universal Setup**.

---

## 📊 Status do Projeto

| Área                           |   Status   | Cobertura / Estado                                                           |
| :----------------------------- | :--------: | :--------------------------------------------------------------------------- |
| **🐧 Linux Provisioning**      | 🟢 Estável | Paridade Debian, Arch e Fedora com receitas idempotentes e modulares         |
| **😈 FreeBSD Provisioning**    | 🟢 Estável | Pacotes, áudio OSS, DRM/KMS e Bhyve automatizados via `sysrc` defensivo      |
| **🪟 Windows Provisioning**    | 🟢 Estável | Receitas nativas integradas via Winget e delegação ao motor do Shell         |
| **⚙️ Orquestrador Central**    | 🟢 Estável | `setup.sh` enxuto (127 linhas) despachando para arquitetura modular em core/ |
| **🛡️ Segurança & Privilégios** | 🟢 Estável | Detecção automática antifrágil de `sudo`/`doas` em `core/elevate.sh`         |
| **🎨 Emissão Visual (TUI)**    | 🟢 Estável | Biblioteca semântica canônica `core/ui.sh` (`_ui_*`) integrada               |
| **🧪 Suite de Auditoria**      |  🟢 100%   | Linters de monólitos, nanos, sintaxe POSIX e réguas                          |

---

## 🎯 Grandes Épicos & Backlog

### 1. 🏛️ Modularização e Eliminação de Rusticidade

- [x] **Desacoplamento de receitas:** Quebrar scripts monolíticos em receitas independentes e modulares por serviço/ferramenta.
- [x] **Idempotência estrita:** Garantir que reexecutar qualquer script não cause efeitos colaterais, reescritas desnecessárias ou falhas (`command -v`).
- [x] **Tratamento de falhas:** Implementar verificações defensivas para cada comando crítico sem abortos cegos.

### 2. 🐚 Conformidade POSIX `/bin/sh` Universal

- [x] Eliminar bashismos residuais nos instaladores e scripts auxiliares (`[ ]`, `.`, `> "/dev/null"`).
- [x] Garantir shebangs canônicos `#!/usr/bin/env sh` em todos os executáveis.
- [x] Validação rigorosa de redirecionamentos e aspas duplas.

### 3. 🎨 Padronização de Emissão (`_ui_*`)

- [x] Importar e utilizar a biblioteca semântica `_ui_*` em todas as rotinas de provisionamento.
- [x] Padronizar mensagens de início de etapa (`==>`), subtarefas (`↳`), alertas (`⚠️ `) e sucesso (`✅`).

### 4. 🌐 Paridade Multiplataforma

- [x] Provisionamento da suite de produtividade Collabora Office Desktop para Linux (Flatpak/AUR), Windows (Winget/Store) e FreeBSD (preparação nativa resiliente).
- [ ] Refinar o suporte às distribuições Linux: Arch Linux, Debian/Ubuntu, Fedora, Void Linux e Alpine Linux.
- [ ] Expandir receitas nativas para FreeBSD 14+ e modernização com ZFS/Jails.

### 5. 🖥️ Bhyve Linux Runtime & FreeBSD Compat Layer

- [x] Receita de provisionamento do Host FreeBSD em `freebsd/container/bhyve.sh` (vm-bhyve, switch, PF NAT, NFSv3 e template).
- [x] Receita de provisionamento do Guest Debian em `linux/desktop/debian/bhyve-guest.sh` (UID/GID 1001, cliente NFSv3, doas/sudo e git-crypt).
- [x] Receita universal do Python Language Server (Pylance) em `common/editors/pylance.sh` e `windows/native/editors/pylance.cmd` cobrindo FreeBSD, Linux e Windows.
- [x] Sincronização de extensões IDE (`sync-extensions.sh`) redirecionando Code OSS no FreeBSD para o catálogo aberto VSCodium.

---

> [!TIP]
> Para detalhes sobre convenções de código e diretrizes de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md).
