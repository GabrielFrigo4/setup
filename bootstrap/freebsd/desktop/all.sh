#!/usr/bin/env sh

### ================================
### FREEBSD DESKTOP COMPLETE BUNDLE
### ================================

set -eu

_dir="$(cd "$(dirname "$0")" && pwd)"
_common="$(cd "${_dir}/../.." && pwd)/common"

echo "📦 [FreeBSD Bundle] Iniciando provisionamento completo do desktop FreeBSD..."

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
_run "${_dir}/system/system.sh"
_run "${_dir}/gui/kde.sh"
_run "${_dir}/devices/audio.sh"
_run "${_dir}/devices/filesystem.sh"
_run "${_dir}/network/wifi.sh"
_run "${_dir}/ports/ports.sh"
_run "${_common}/fonts/fonts.sh"

echo "✅ [FreeBSD Bundle] Instalação do desktop FreeBSD finalizada com sucesso!"
exit 0
