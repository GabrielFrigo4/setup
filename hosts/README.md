# 💻 Perfis Opt-In de Hardware (`hosts/`)

> Receitas específicas de hardware físico isoladas do provisionamento portátil principal (`freebsd/` e `linux/`).

---

## 🎯 Finalidade

Para preservar a portabilidade universal das receitas em `freebsd/` e `linux/`, ajustes específicos de placas-mãe, drivers DRM específicos, nomes rígidos de interfaces (`re0`, `rtw880`), roteamento de áudio (`hw.snd.default_unit`, `dev.pcm.2`) e políticas ACPI residem nesta pasta como perfis **opt-in**.

Nenhuma receita de `hosts/` é executada automaticamente pelo perfil `base` ou `desktop`; elas são invocadas explicitamente via `setup.sh --profile=host`.

---

## 📂 Catálogo de Hosts

| Perfil                                           | Plataforma | Hardware / Escopo                                                                               |
| :----------------------------------------------- | :--------- | :---------------------------------------------------------------------------------------------- |
| [`vostro3520-freebsd.sh`](vostro3520-freebsd.sh) | FreeBSD    | Dell Vostro 3520 (Intel Alder Lake DRM `< 15.2` / `>= 15.2`, `re0` + `rtw880`, áudio/ACPI/devd) |

---

## 🚀 Execução

Executar o perfil opt-in diretamente a partir do clone soberano:

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/setup.sh" --profile=host
```

Ou executar o script do hardware diretamente:

```sh
sh "${XDG_DATA_HOME:-${HOME}/.local/share}/setup/hosts/vostro3520-freebsd.sh"
```
