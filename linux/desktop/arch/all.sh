#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Arch Linux Complete Bundle
# ----------------------------------------------------------------
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
_run "${_common}/cli/core.sh"
_run "${_common}/vcs/tools.sh"
_run "${_common}/editors/install.sh"
_run "${_common}/editors/editors.sh"
_run "${_common}/graphics/windowing.sh"
_run "${_common}/graphics/shaders.sh"
_run "${_common}/wasm/emscripten.sh"
_run "${_common}/media/cli.sh"
_run "${_common}/docs/typesetting.sh"
_run "${_common}/fonts/fonts.sh"
_run "${_common}/web/browsers.sh"
_run "${_common}/security/re.sh"
_run "${_common}/security/wireshark.sh"
_run "${_common}/ai/ollama.sh"
_run "${_common}/linters/linters.sh"
_run "${_dir}/system/diagnostics.sh"

echo "✅ [Arch Bundle] Instalação do Arch Linux finalizada com sucesso!"
exit 0
