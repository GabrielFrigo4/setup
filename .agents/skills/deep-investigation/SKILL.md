---
name: deep-investigation
description: >-
  Deep root-cause technical investigation and primary sources research for Universal Setup.
  Use when diagnosing package manager failures, kernel/sysctl configurations,
  FreeBSD Jail isolation, container runtimes (Incus, Podman), and hardware driver setup.
---

# Deep Investigation — Upstream Sources & Infrastructure Diagnostics

Esta skill define o protocolo de investigação técnica de excelência no repositório **Universal Setup Environment** (`Setup`).

Quando nos deparamos com falhas de compilação de pacotes, conflitos de dependência em gerenciadores de pacotes, problemas de rede em containers ou inconsistências de sysctl, **nunca devemos recorrer a adivinhações superficiais**.

---

## 1. Regra de Ouro: Fontes Primárias Atuais

1. **FreeBSD:** Consulte sempre `man.freebsd.org` na versão ativa (15.1/CURRENT), `freebsd-src` e o handbook oficial.
2. **Linux & Distros:** Consulte a documentação oficial do Fedora, Arch Wiki (excelente para referências técnicas) e manuais Debian.
3. **Containers & Virtualização:** Documentação oficial do Incus (linuxcontainers.org), Podman docs e BastilleBSD docs.

---

## 2. Hierarquia de Fontes Primárias

```text
Nível 1: Código-Fonte Upstream & Man Pages Atuais (Ground Truth)
   ↳ freebsd-src, systemd C sources, Linux kernel docs, Incus sources.

Nível 2: Documentação Oficial da Distribuição
   ↳ man.freebsd.org, docs.fedoraproject.org, wiki.archlinux.org.

Nível 3: Release Notes e Upstream Git
   ↳ Commit logs de patches e mudanças de arquitetura.
```

---

## 3. Protocolo de Diagnóstico

1. **Isolar o Erro:** Capture a mensagem literal do gerenciador de pacotes ou serviço com verbose.
2. **Identificar o Subsistema:** Verifique permissões, capacidades Linux/FreeBSD, cgroups e status de sockets.
3. **Validar a Solução Idempotente:** Garanta que a correção possa ser executada repetidas vezes sem falhas.
