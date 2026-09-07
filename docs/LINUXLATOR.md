# 🐧 Linuxlator (FreeBSD Linux Compatibility)

O **Linuxlator** é a camada nativa de compatibilidade do FreeBSD que permite a execução de binários Linux sem a sobrecarga de uma máquina virtual completa (como o bhyve).

---

## 🎯 Filosofia e Uso no Host

Para respeitar a filosofia de **Clean Host**, o Linuxlator no host do FreeBSD atua exclusivamente como uma **extensão do catálogo de software**:

- Se um aplicativo ou utilitário binário essencial não estiver disponível nos pacotes (`pkg`) ou nos `ports` do FreeBSD, ele pode ser executado via Linuxlator.
- O ambiente base do Linux (`/compat/linux`) é mantido limpo e gerenciado exclusivamente pelo ecossistema de pacotes do FreeBSD.
- Não usamos o Linuxlator no host para empilhar ambientes de compilação ou servidores complexos; para isso, usamos Jails ou VMs dedicadas.

### Ativação no Host (FreeBSD 14+)

O kernel ativa o suporte nativo via `linux_enable="YES"` na receita [`bootstrap/freebsd/desktop/emulation/linuxlator.sh`](../bootstrap/freebsd/desktop/emulation/linuxlator.sh). No FreeBSD moderno, a base de userland padrão é o **Rocky Linux 9** (`linux_base-rl9`) ou Ubuntu:

```sh
# Ativação via receita do Cookbook:
sh bootstrap/freebsd/desktop/emulation/linuxlator.sh

# Userland moderna do Linux (Rocky Linux 9):
sudo pkg install emulators/linux_base-rl9
```

---

## 🏛️ Linuxlator em Jails (Via BastilleBSD)

Para cenários onde é necessário rodar binários Linux com maior isolamento de filesystem e rede (como ambientes de teste ou toolchains específicas):

1. **Performance Nativa:** Zero sobrecarga de hipervisor; syscalls do Linux são traduzidos em tempo real para syscalls do kernel FreeBSD.
2. **Uso Mínimo de Memória:** Uma Jail Linux consome a mesma quantidade de memória de processos comuns do FreeBSD.
3. **Inicialização Instantânea:** Sobe em menos de 1 segundo, sem ciclo de boot de kernel.
4. **BastilleBSD:** O Bastille provê suporte para criar Jails rodando userlands Linux completas mantendo a raiz do host perfeitamente imaculada.
