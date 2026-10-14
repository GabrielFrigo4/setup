#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Desktop Complete Bundle
# ----------------------------------------------------------------
set -eu

_dir="$(cd "$(dirname "$0")" && pwd)"
_common="$(cd "${_dir}/../.." && pwd)/common"

_setup_root="$(cd "${_dir}/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_ui_step "Iniciando provisionamento completo do desktop FreeBSD..."

_run() {
	_script="$1"
	if [ -f "${_script}" ]; then
		_ui_sub "Executando: $(basename "${_script}")"
		sh "${_script}"
	fi
}

### --------------------------------
### Execução Sequencial
### --------------------------------
_run "${_dir}/system/system.sh"
_run "${_dir}/system/ttys.sh"
_run "${_dir}/system/zfs-arc.sh"
_run "${_dir}/gui/kde.sh"
_run "${_dir}/devices/audio.sh"
_run "${_dir}/devices/filesystem.sh"
_run "${_dir}/network/wifi.sh"
_run "${_dir}/ports/ports.sh"
_run "${_common}/cli/core.sh"
_run "${_common}/vcs/tools.sh"
_run "${_common}/editors/install.sh"
_run "${_common}/editors/editors.sh"
_run "${_common}/editors/pylance.sh"
_run "${_common}/graphics/windowing.sh"
_run "${_common}/graphics/shaders.sh"
_run "${_common}/wasm/emscripten.sh"
_run "${_common}/media/cli.sh"
_run "${_common}/docs/typesetting.sh"
_run "${_common}/fonts/fonts.sh"
_run "${_common}/web/browsers.sh"
_run "${_common}/linters/linters.sh"
_run "${_common}/ai/ollama.sh"
_run "${_common}/security/wireshark.sh"

_ui_ok "Instalação do desktop FreeBSD finalizada com sucesso!"
exit 0
