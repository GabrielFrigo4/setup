#!/usr/bin/env sh
# ----------------------------------------------------------------
# Utility: Multiplatform System & Provisioning Doctor
# ----------------------------------------------------------------
set -eu

_repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_repo_root}/core/ui.sh"
. "${_repo_root}/core/detect.sh"

_warn=0

_check_cmd() {
	if command -v "$1" > "/dev/null" 2>&1; then
		_ui_ok "$2 ($1): instalado"
	else
		_ui_warn "$2 ($1): ausente"
		_warn=$((_warn + 1))
	fi
}

_ui_banner "Setup Doctor — Diagnóstico Multiplataforma"
_ui_info "SO: ${DETECTED_OS} | Distro: ${DETECTED_DISTRO} | Pkg: ${DETECTED_PKG_MGR} | TTY: ${DETECTED_CONSOLE_FONT}"

### ================================
### FERRAMENTAS ESSENCIAIS
### ================================
_ui_step "1. Ferramentas essenciais do ecossistema"
_check_cmd "git" "Controle de versão"
_check_cmd "curl" "Download & HTTP"
_check_cmd "python3" "Auditorias estáticas"
_check_cmd "prettier" "Formatador Markdown/JSON"

### ================================
### ELEVACAO DE PRIVILEGIOS
### ================================
_ui_step "2. Mecanismo de elevação administrativa"
if command -v doas > "/dev/null" 2>&1; then
	_ui_ok "Elevação preferencial ativa: doas"
elif command -v sudo > "/dev/null" 2>&1; then
	_ui_ok "Elevação ativa: sudo"
elif [ "$(id -u)" -eq 0 ]; then
	_ui_info "Sessão root direta ativa"
else
	_ui_err "Nenhum elevador (doas/sudo) encontrado!"
	_warn=$((_warn + 1))
fi

### ================================
### DIAGNOSTICO POR PLATAFORMA
### ================================
_ui_step "3. Subsistema gráfico, áudio, storage e containers (${DETECTED_OS})"
if [ "${DETECTED_OS}" = "freebsd" ]; then
	if command -v zpool > "/dev/null" 2>&1; then
		_pools="$(zpool list -H -o name,health 2> "/dev/null" | tr '\n' ' ' || true)"
		_arc="$(sysctl -n vfs.zfs.arc.max 2> "/dev/null" || echo "desconhecido")"
		_ui_ok "ZFS pools: ${_pools:-nenhum} | ARC max: ${_arc}"
	fi
	if ls /dev/dsp* > "/dev/null" 2>&1; then
		_ui_ok "Áudio OSS nativo detectado (/dev/dsp*)"
	else
		_ui_warn "Dispositivos OSS (/dev/dsp*) ausentes"
		_warn=$((_warn + 1))
	fi
	pgrep -x sndiod > "/dev/null" 2>&1 && _ui_ok "Daemon sndiod ativo" || _ui_info "Daemon sndiod inativo"
	[ -e "/dev/dri/renderD128" ] && _ui_ok "DRM GPU (/dev/dri/renderD128) presente" || _ui_info "Nó DRM renderD128 não detectado"
	command -v vainfo > "/dev/null" 2>&1 && _ui_ok "VA-API disponível (vainfo)" || _ui_info "vainfo ausente"
	for _ct in vm bastille podman; do
		command -v "${_ct}" > "/dev/null" 2>&1 && _ui_ok "Virtualização/Container (${_ct}): disponível" || _ui_info "${_ct}: não instalado"
	done
elif [ "${DETECTED_OS}" = "linux" ]; then
	_session="${XDG_SESSION_TYPE:-unknown}"
	if [ "${_session}" = "wayland" ]; then
		_ui_ok "Sessão gráfica Wayland nativa ativa"
	else
		_ui_info "Sessão gráfica atual: ${_session}"
	fi
	if command -v vainfo > "/dev/null" 2>&1 || [ -e "/dev/dri/renderD128" ]; then
		_ui_ok "Aceleração gráfica DRM/VA-API detectada"
	else
		_ui_info "Aceleração DRM/VA-API direta não detectada"
	fi
	if command -v wpctl > "/dev/null" 2>&1 || command -v pactl > "/dev/null" 2>&1; then
		_ui_ok "Subsistema de áudio PipeWire/PulseAudio ativo"
	else
		_ui_warn "PipeWire/PulseAudio (wpctl/pactl) não encontrado"
		_warn=$((_warn + 1))
	fi
	for _ct in incus podman docker virsh; do
		command -v "${_ct}" > "/dev/null" 2>&1 && _ui_ok "Container/VM (${_ct}): disponível" || _ui_info "${_ct}: não instalado"
	done
elif [ "${DETECTED_OS}" = "windows" ]; then
	_ui_info "Ambiente Windows (${MSYSTEM:-native})"
	for _wc in winget.exe scoop pwsh wsl.exe; do
		command -v "${_wc}" > "/dev/null" 2>&1 && _ui_ok "Ferramenta Windows (${_wc}): disponível" || _ui_info "${_wc}: ausente"
	done
fi

echo ""
if [ "${_warn}" -eq 0 ]; then
	_ui_ok "Setup Doctor: sistema verificado sem pendências críticas!"
else
	_ui_warn "Setup Doctor: diagnóstico concluído com ${_warn} observação(ões)."
fi
