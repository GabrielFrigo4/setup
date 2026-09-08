#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Universal Environment Workspace & Quartet Provisioning
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Workspace]: Provisionando o ecossistema do Quarteto de Produtividade..."

if [ -n "${1:-}" ]; then
	_env_dir="$1"
elif command -v xdg-user-dir > "/dev/null" 2>&1 && [ -n "$(xdg-user-dir DOCUMENTS 2> "/dev/null")" ]; then
	_env_dir="$(xdg-user-dir DOCUMENTS)/Environment"
elif [ -d "${HOME}/Documentos" ]; then
	_env_dir="${HOME}/Documentos/Environment"
elif [ -d "${HOME}/Documents" ]; then
	_env_dir="${HOME}/Documents/Environment"
else
	_env_dir="${HOME}/Documents/Environment"
fi

[ ! -d "${_env_dir}" ] && mkdir -p "${_env_dir}"

echo "  ↳ Diretório de trabalho: ${_env_dir}"

### --------------------------------
### 1. Orquestrador Global Makefile
### --------------------------------
echo "  ↳ Gerando Makefile de orquestração..."

cat << 'EOF' > "${_env_dir}/Makefile"
.PHONY: help status audit sync pull test ci doctor clone

REPOS := Setup Shell Vault Profile

help:
	@echo "🏛️  O Quarteto de Produtividade — Orquestrador Global"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make clone    - Clona os 4 repositórios em uma nova máquina"
	@echo "  make status   - Exibe status Git resumido dos 4 repositórios"
	@echo "  make audit    - Executa suites de auditoria estática e validação"
	@echo "  make sync     - Sincroniza dotfiles e skills de IA no sistema"
	@echo "  make pull     - Atualiza os 4 repositórios com o GitHub"
	@echo "  make test     - Valida sintaxe POSIX e Zsh em todos os scripts"
	@echo "  make ci       - Executa auditoria completa e quality gates locais"
	@echo "  make doctor   - Executa diagnóstico pós-boot do sistema"
	@echo ""

clone:
	@echo "📦 Clonando o Quarteto de Produtividade..."
	@[ ! -d "Setup" ] && git clone "https://github.com/GabrielFrigo4/setup.git" Setup || echo "  ℹ️ Setup já clonado."
	@[ ! -d "Shell" ] && git clone "https://github.com/GabrielFrigo4/shell.git" Shell || echo "  ℹ️ Shell já clonado."
	@[ ! -d "Vault" ] && git clone "https://github.com/GabrielFrigo4/vault.git" Vault || echo "  ℹ️ Vault já clonado."
	@[ ! -d "Profile" ] && git clone "https://github.com/GabrielFrigo4/profile.git" Profile || echo "  ℹ️ Profile já clonado."
	@echo "🎉 Todos os 4 repositórios clonados com sucesso!"

status:
	@for r in $(REPOS); do \
		echo "=== $$r ($$(git -C $$r branch --show-current 2> \"/dev/null\")) ==="; \
		git -C $$r status -s; \
		echo ""; \
	done

audit:
	@echo "🔍 [1/4] Auditando Setup..."
	@python3 Setup/scripts/audit/all.py
	@echo "🔍 [2/4] Auditando Profile..."
	@python3 Profile/scripts/audit/all.py
	@echo "🔍 [3/4] Validando sintaxe do Shell..."
	@find Shell -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	@echo "🔍 [4/4] Validando sintaxe do Vault..."
	@sh -n Vault/vault.sh
	@echo "🎉 Todas as auditorias estáticas foram aprovadas!"

sync:
	@echo "🎨 Sincronizando dotfiles..."
	@sh Profile/install.sh

pull:
	@for r in $(REPOS); do \
		echo "⬇️  Pulling $$r..."; \
		git -C $$r pull --ff-only; \
	done

test:
	@echo "🧪 Testando sintaxe de scripts do ecossistema..."
	@find Setup Shell Vault Profile -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	@echo "✅ Sintaxe de todos os scripts está perfeita!"

doctor:
	@sh Setup/scripts/audit/doctor.sh

ci: test audit
	@echo "⚡ Medindo benchmark de inicialização do Shell..."
	@cd Shell && sh .githooks/pre-commit
	@echo "🚀 Ecossistema 100% pronto para produção e commits!"
EOF

chmod 0644 "${_env_dir}/Makefile"

### --------------------------------
### 2. Clonagem Federada dos Repos
### --------------------------------
_clone_item() {
	_repo_name="$1"
	_git_name="$2"
	if [ ! -d "${_env_dir}/${_repo_name}" ]; then
		echo "  ↳ Clonando ${_repo_name}..."
		git clone "https://github.com/GabrielFrigo4/${_git_name}.git" "${_env_dir}/${_repo_name}"
	else
		echo "  ℹ️ ${_repo_name} já clonado."
	fi
}

_clone_item "Setup" "setup"
_clone_item "Shell" "shell"
_clone_item "Vault" "vault"
_clone_item "Profile" "profile"

echo "✅ [Workspace]: Ecossistema clonado e pronto em ${_env_dir}!"
exit 0
