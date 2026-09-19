# 🗺️ Roadmap & Backlog

> Planejamento estratégico, status operacional e visão de futuro para a evolução do **Universal Setup**.

---

## 📊 Status do Projeto

| Área                           |      Status       | Cobertura / Estado                                                           |
| :----------------------------- | :---------------: | :--------------------------------------------------------------------------- |
| **🐧 Linux Provisioning**      | 🟡 Em Refatoração | Scripts funcionais, porém necessitam de modularização e idempotência atômica |
| **😈 FreeBSD Provisioning**    | 🟡 Em Refatoração | Base de pacotes e serviços configurada; polimento de scripts de automação    |
| **🪟 Windows Provisioning**    | 🟡 Em Refatoração | Receitas batch e PowerShell ativas; necessidade de alinhamento TUI           |
| **⚙️ Orquestrador Central**    | 🟡 Em Refatoração | `setup.sh` monolítico em transição para arquitetura desacoplada de receitas  |
| **🛡️ Segurança & Privilégios** |    🟢 Estável     | Detecção automática de `sudo`/`doas` com elevação cirúrgica                  |
| **🎨 Emissão Visual (TUI)**    |  🟡 Em Migração   | Transição em andamento para a biblioteca semântica canônica `_ui_*`          |
| **🧪 Suite de Auditoria**      |      🟢 100%      | Linters de monólitos, nanos, sintaxe POSIX e réguas                          |

---

## 🎯 Grandes Épicos & Backlog

### 1. 🏛️ Modularização e Eliminação de Rusticidade

- [ ] **Desacoplamento de receitas:** Quebrar scripts monolíticos em receitas independentes e modulares por serviço/ferramenta.
- [ ] **Idempotência estrita:** Garantir que reexecutar qualquer script não cause efeitos colaterais, reescritas desnecessárias ou falhas.
- [ ] **Tratamento de falhas:** Implementar verificações defensivas para cada comando crítico sem abortos cegos.

### 2. 🐚 Conformidade POSIX `/bin/sh` Universal

- [ ] Eliminar bashismos residuais nos instaladores e scripts auxiliares.
- [ ] Garantir shebangs canônicos `#!/usr/bin/env sh` em todos os executáveis.
- [ ] Validação rigorosa de redirecionamentos e aspas duplas.

### 3. 🎨 Padronização de Emissão (`_ui_*`)

- [ ] Importar e utilizar a biblioteca semântica `_ui_*` em todas as rotinas de provisionamento.
- [ ] Padronizar mensagens de início de etapa (`==>`), subtarefas (`↳`), alertas (`⚠️ `) e sucesso (`✅`).

### 4. 🌐 Paridade Multiplataforma

- [ ] Refinar o suporte às distribuições Linux: Arch Linux, Debian/Ubuntu, Fedora, Void Linux e Alpine Linux.
- [ ] Expandir receitas nativas para FreeBSD 14+ e modernização com ZFS/Jails.
- [ ] Aprimorar receitas do Windows (`windows/native/`) com scripts PowerShell limpos e Winget/Scoop.

---

> [!TIP]
> Para detalhes sobre convenções de código e diretrizes de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md).
