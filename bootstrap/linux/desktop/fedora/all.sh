#!/usr/bin/env sh

### ================================
### FEDORA DESKTOP COMPLETE BUNDLE
### ================================

set -eu

_dir="$(cd "$(dirname "$0")" && pwd)"
_common="$(cd "${_dir}/../../.." && pwd)/common"

echo "📦 [Fedora Bundle] Iniciando provisionamento completo do desktop Fedora..."

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
_run "${_dir}/desktop/gnome.sh"
_run "${_dir}/desktop/fonts.sh"
_run "${_dir}/tools/cli.sh"
_run "${_common}/fonts/fonts.sh"
_run "${_common}/linters/linters.sh"

echo "✅ [Fedora Bundle] Instalação do desktop Fedora finalizada com sucesso!"
exit 0
