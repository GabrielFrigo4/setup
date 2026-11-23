# ☁️ Servidores Linux Headless

> Provisionamento minimalista de servidores Linux headless (Ubuntu / Debian / multi-distro).

---

## 🎯 Finalidade

Reúne a receita base de servidores Ubuntu e integra-se às receitas universais em [`../common/`](../common/README.md) e políticas de elevação em [`../../common/system/`](../../common/system/README.md) através do perfil `--profile=server` em [`../../setup.sh`](../../setup.sh).

---

## 📂 Catálogo de Recursos

| Recurso                                                                | Tipo    | Descrição                                                                |
| :--------------------------------------------------------------------- | :------ | :----------------------------------------------------------------------- |
| **[`ubuntu.sh`](ubuntu.sh)**                                           | Receita | Baseline de servidor Ubuntu (`apt-clone`, `tmux`)                        |
| **[`../../common/system/persist.sh`](../../common/system/persist.sh)** | Receita | Elevação com `doas` e `sudo` com senha e persistência de sessão (`0440`) |

---

## 🚀 Como Executar (Clone Soberano)

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/setup.sh" --profile=server
```
