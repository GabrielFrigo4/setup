# 🧠 A Filosofia do Ecossistema

A visão e o design arquitetural de longo prazo para este ambiente de desenvolvimento baseiam-se em quatro princípios imutáveis que orientam cada módulo do repositório **Setup**.

---

## 1. "Clean Host" (Isolamento Extremo)

A regra de ouro do ambiente é: **O sistema operacional nativo (o _host_) deve ser tratado como um santuário portátil.**

Em vez de acumular runtimes, bancos de dados e dependências pesadas diretamente no host, utilizamos virtualização e conteinerização para manter o SO enxuto e reprodutível. O _host_ é responsável por:

- Prover a interface gráfica nativa em Wayland (`GNOME` no Fedora Workstation, `KDE Plasma 6` no FreeBSD Desktop).
- Gerenciar drivers de hardware, áudio, vídeo e rede portáteis.
- Executar editores residentes e navegadores.
- Rodar o _hypervisor_ ou engine de containers (`Incus`, `Podman`, `Bastille Jails`, `Bhyve`, `Hyper-V` / `WSL2`).

Ferramentas adicionais de desenvolvimento no host (compiladores de shaders, Python stack, Ollama, linters) ficam isoladas no perfil opt-in `--profile=dev-host`.

---

## 2. Separação Portabilidade vs. Hardware Pessoal (`hosts/`)

Receitas em `freebsd/` e `linux/` pertencem ao domínio portátil e devem funcionar em qualquer máquina compatível. Quirks específicos de hardware físico (como travas de versão DRM para GPU Intel Alder Lake, identificadores fixos de placa `re0`/`rtw880`, unidades PCM ou políticas ACPI de notebook) residem exclusivamente em `hosts/` (ex: `hosts/vostro3520-freebsd.sh`) como perfis opt-in via `--profile=host`.

---

## 3. ZFS: A Base da Segurança e Flexibilidade

O **ZFS** é adotado como fundação de storage no FreeBSD e via OpenZFS no Linux sempre que aplicável:

- **Snapshots & Boot Environments (`bectl`):** Pontos de restauração instantâneos antes de upgrades de driver ou kernel.
- **Integração com Containers/VMs:** Datasets dedicados para Jails (`Bastille`) e volumes de bloco ZVOL para convidados `Bhyve` com dimensionamento proporcional de ARC (`4/16` RAM) e VM (`1/16` RAM).

---

## 4. "Uma coisa, um lugar" (O Quarteto de Modularidade)

O ambiente completo é desmembrado no **Quarteto de Produtividade** (complementado pela **Suíte de Editores**):

1. **Setup (`~/.local/share/setup`):** Provisionamento privilegiado de sistema operacional via Clone Soberano (`bootstrap.sh`), drivers, containers e `hosts/`.
2. **Shell (`/usr/local/share/shell`):** Motor interativo de terminal, aliases, funções e prompts (< 64ms).
3. **Vault (`~/.local/share/vault`):** Cofre privado para chaves SSH/PuTTY, segredos `.env` e credenciais de rede.
4. **Profile (`~/.config/profile`):** Dotfiles declarativos de usuário, terminais, linters e skills portáteis de IA.
