#!/usr/bin/env sh

### ================================
### ARCH LINUX COMPLETE BUNDLE
### ================================

set -eu

_dir="$(cd "$(dirname "$0")" && pwd)"
_common="$(cd "${_dir}/../../.." && pwd)/common"

echo "📦 [Arch Bundle] Iniciando provisionamento completo do Arch Linux..."

_run() {
	_script="$1"
	if [ -f "${_script}" ]; then
		echo "  ▶️ Executando: $(basename "${_script}")"
		sh "${_script}"
	fi
}

### --------------------------------
### Execução Sequencial
### --------------------------------
_run "${_dir}/system/base.sh"
_run "${_dir}/desktop/hardware.sh"
_run "${_dir}/tools/cli.sh"
_run "${_dir}/editors/editors.sh"
_run "${_dir}/apps/desktop.sh"
_run "${_dir}/system/diagnostics.sh"
_run "${_common}/fonts/fonts.sh"
_run "${_common}/linters/linters.sh"

echo "✅ [Arch Bundle] Instalação do Arch Linux finalizada com sucesso!"
exit 0
