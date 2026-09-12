.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Setup Provisioning
# ----------------------------------------------------------------

.PHONY: help audit test doctor ci

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	cmd() { printf "    \033[36mmake %-20s\033[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  \033[1;33m%s\033[0m\n" "$$1"; }; \
	sub() { printf "  \033[1;34m  ── %s ──\033[0m\n" "$$1"; }; \
	printf "\n  \033[1;37mUniversal Setup — Provisionamento Ativo de Sistemas Operacionais\033[0m\n"; \
	printf "  ============================================================\n"; \
	sec "Auditoria & Qualidade:"; \
	cmd "test"           "Valida sintaxe POSIX em todas as receitas de provisionamento"; \
	cmd "audit"          "Executa a suíte de auditoria completa e quality gates"; \
	cmd "ci"             "Executa suite completa de CI local"; \
	sec "Diagnóstico:"; \
	cmd "doctor"         "Executa diagnóstico de saúde e sanity check pós-boot do sistema"; \
	echo ""

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

doctor:
	sh scripts/audit/doctor.sh

ci: test audit
	echo "🚀 Setup 100% aprovado no CI local!"
