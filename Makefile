.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Setup Provisioning
# ----------------------------------------------------------------

.PHONY: help hooks audit test fix-banners doctor ci

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-22s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	sub() { printf "  $${_e}[1;34m  ── %s ──$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37mUniversal Setup — Provisionamento Ativo de Sistemas Operacionais$${_e}[0m\n"; \
	printf "  ============================================================\n"; \
	sec "Setup & Ganchos:"; \
	cmd "hooks"          "Configura e aplica permissões canônicas em .githooks"; \
	sec "Auditoria & Qualidade:"; \
	cmd "test"           "Valida sintaxe POSIX em todas as receitas de provisionamento"; \
	cmd "audit"          "Executa a suíte de auditoria completa e quality gates"; \
	cmd "ci"             "Executa suite completa de CI local"; \
	sec "Diagnóstico:"; \
	cmd "doctor"         "Executa diagnóstico de saúde e sanity check pós-boot do sistema"; \
	echo ""

### ================================
### GIT HOOKS & PERMISSIONS
### ================================
hooks:
	echo "🪝 Configurando ganchos Git (.githooks)..."
	chmod 0755 .githooks/pre-commit .githooks/commit-msg 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "  ✅ Setup: core.hooksPath -> .githooks"

### ================================
### AUDIT & QUALITY GATES
### ================================
audit:
	echo "🔍 Executando suíte de auditoria do Setup..."
	python3 scripts/audit/all.py

test:
	echo "🧪 Validando sintaxe POSIX das receitas de provisionamento..."
	find . -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	echo "✅ Todas as receitas POSIX estão válidas!"

fix-banners:
	echo "📏 Normalizando réguas de banners de cabeçalho e seções..."
	python3 scripts/audit/banners.py --fix
	echo "✅ Réguas de banners normalizadas com sucesso!"

doctor:
	sh scripts/audit/doctor.sh

ci: test audit
	echo "🚀 Setup 100% aprovado no CI local!"
