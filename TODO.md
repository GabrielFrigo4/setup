# 🗺️ Roadmap & Status — Universal Setup

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> Arquitetura **Clone Soberano (`bootstrap.sh`) + Clean Host + Separação `hosts/`**, biblioteca `core/pkg.sh`, unificação declarativa no Windows (`winget.json`) e receitas portáteis foram integralmente concluídas.

---

## 📊 Matriz de Maturidade

| Área                             |   Status    | Cobertura / Estado                                                                                                      |
| :------------------------------- | :---------: | :---------------------------------------------------------------------------------------------------------------------- |
| **Clone Soberano**               | 🟢 Estável  | `bootstrap.sh` clona/atualiza em `~/.local/share/setup`, aplica `0755` e dispara `setup.sh`                             |
| **Módulos Core (`core/`)**       | 🟢 Estável  | `detect.sh`, `elevate.sh`, `pkg.sh` (`_pkg_update`/`_pkg_install`), `perms.sh` e `ui.sh` (`_ui_*`)                      |
| **Orquestrador (`setup.sh`)**    | 🟢 Estável  | 4 camadas e perfis reais (`base`, `desktop`, `virtualization`, `dev-host`, `host`, `server`, `doctor`, `audit`, `test`) |
| **Hardware Isolado (`hosts/`)**  | 🟢 Estável  | Quirks físicos opt-in em `hosts/vostro3520-freebsd.sh` com regra Intel Alder Lake `< 15.2` / `>= 15.2`                  |
| **Linux Provisioning**           | 🟢 Estável  | Paridade Fedora Workstation, Arch Linux, Debian GNU/Linux, servidor Ubuntu e instâncias WSL2 (Fedora, Arch, Debian)     |
| **FreeBSD Provisioning**         | 🟢 Estável  | Base portátil (`system.sh`, `sysctl.sh`, `vt_autofont`), KDE Plasma 6 Wayland, Jails, Bastille, Podman e Bhyve PF       |
| **Windows & MSYS2**              | 🟢 Estável  | `winget.json` declarativo, `scoop.cmd` idempotente, `setup.ps1`, `registry/`, `hyper-v.cmd` e 7 receitas UCRT64 `_ui_*` |
| **ISOs Oficiais (`common/iso`)** | 🟢 Estável  | Motor único `download.sh` com dispatch tabular e verificação criptográfica para 10 sistemas operacionais                |
| **Stack Python & LibreOffice**   | 🟢 Estável  | `common/languages/python.sh`, `python.cmd`, `common/office/office.sh` (`pkg -> dnf -> apt -> pacman -> winget`)         |
| **Quality Gates & Doctor**       | 🟢 Aprovado | 9/9 auditores aprovados (incluindo `links.py`, `comments.py`, `skills.py`) e `doctor.sh` multiplataforma                |

---

## 🛡️ Atributos Entregues

- **Modelo Clone Soberano + Clean Host:** Substituição definitiva do acoplamento antigo por `bootstrap.sh` (`~/.local/share/setup`) e orquestração em camadas em `setup.sh`.
- **Portabilidade FreeBSD & Regra `< 15.2`:** Remoção de quirks pessoais de `system.sh` e `sysctl.sh` para `hosts/vostro3520-freebsd.sh`, mantendo `"syslogd_flags=-ss"` e blindagem Intel Alder Lake automática por versão (`freebsd-version -u`).
- **Hardening PF Parametrizado no Bhyve:** Regras defensivas (`pflog`, `<bruteforce>`, `<lan_nets>`, `if-bound`, `syncookies adaptive`, `urpf-failed`, `graphics_listen="127.0.0.1"`) preservadas com autodetecção segura de `WIRED_IF`, `WIFI_IF`, `ZFS_POOL`, `VM_NET` e `JAIL_NET`.
- **Unificação Windows & MSYS2:** Manifesto declarativo `windows/native/pkg/winget.json` via `winget import`, `scoop.cmd` idempotente, atalhos PowerShell em `Start Menu\Programs\Custom`, consolidação de `.reg`/`hyper-v.cmd` em `windows/native/` e padronização `_ui_*` nos 7 scripts `windows/msys2/`.
- **Clean-Break de Fósseis & Redundâncias:** Expurgo de receitas obsoletas de banco de dados no host, frameworks individuais de editores, `choco.cmd`, scripts de servidor/conexão antigos e consolidação de 10 scripts ISO em `common/iso/download.sh`.
- **Documentação Sincronizada:** Atualização integral de READMEs, `docs/`, regras e skills com zero links quebrados e zero URLs Markdown dentro de blocos de código.

---

## 📌 Backlog & Próximos Passos

- Monitorar estabilização upstream do `drm-612-kmod` no FreeBSD 15.2-RELEASE para validação contínua do ramo `>= 15.2` em `hosts/vostro3520-freebsd.sh`.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
