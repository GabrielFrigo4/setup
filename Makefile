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
	echo "📦 Universal Setup — Provisionamento Ativo de SO"
	echo ""
	echo "Comandos disponíveis:"
	echo "  make audit    - Executa a suíte de auditoria e quality gates"
	echo "  make test     - Valida sintaxe POSIX em todas as receitas"
	echo "  make doctor   - Executa diagnóstico pós-boot do sistema"
	echo "  make ci       - Executa suite completa de CI local"
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
