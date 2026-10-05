#!/usr/bin/env sh
# ----------------------------------------------------------------
# Utility: System and Provisioning Doctor
# ----------------------------------------------------------------
set -eu

echo "🩺 [Setup Doctor] Iniciando diagnóstico de integridade do sistema..."

_warn=0

_check_cmd() {
	_cmd="$1"
	_desc="$2"
	if command -v "${_cmd}" > "/dev/null" 2>&1; then
		echo "  ✅ ${_desc} (${_cmd}): Instalado"
	else
		echo "  ⚠️ ${_desc} (${_cmd}): Ausente"
		_warn=$((_warn + 1))
	fi
}

### ================================
### Ferramentas Essenciais
### ================================
echo "↳ 1. Ferramentas essenciais do ecossistema..."
_check_cmd "git" "Controle de Versão"
_check_cmd "curl" "Download & API"
_check_cmd "python3" "Auditorias & Scripts"

### ================================
### Privilégios & Elevação
### ================================
echo "↳ 2. Mecanismo de elevação de privilégios..."
if command -v doas > "/dev/null" 2>&1; then
	echo "  ✅ Mecanismo ativo: doas (Recomendado/Preferencial)"
elif command -v sudo > "/dev/null" 2>&1; then
	echo "  ✅ Mecanismo ativo: sudo"
elif [ "$(id -u)" -eq 0 ]; then
	echo "  ℹ️ Sessão root direta ativa"
else
	echo "  ❌ Nenhum elevador (doas/sudo) detectado!"
	_warn=$((_warn + 1))
fi

### ================================
### Protocolo Gráfico & Wayland
### ================================
echo "↳ 3. Ambiente gráfico & compositor..."
_session="${XDG_SESSION_TYPE:-unknown}"
if [ "${_session}" = "wayland" ]; then
	echo "  ✅ Protocolo Wayland nativo ativo"
elif [ "${_session}" = "x11" ]; then
	echo "  ℹ️ Sessão em X11 (Considere migrar para Wayland nativo)"
else
	echo "  ℹ️ Sessão TTY / Headless / Desconhecida (${_session})"
fi

### ================================
### Aceleração de Vídeo & Som
### ================================
echo "↳ 4. Aceleração gráfica & subsistema de som..."
if command -v vainfo > "/dev/null" 2>&1; then
	echo "  ✅ Utilitário VA-API presente (vainfo)"
elif [ -e "/dev/dri/renderD128" ]; then
	echo "  ✅ Dispositivo /dev/dri/renderD128 presente"
else
	echo "  ℹ️ Aceleração VA-API direta não detectada"
fi

if command -v pactl > "/dev/null" 2>&1; then
	echo "  ✅ Subsistema de áudio detectado (PipeWire/PulseAudio)"
else
	echo "  ℹ️ pactl não encontrado"
fi

echo "================================"
if [ "${_warn}" -eq 0 ]; then
	echo "🎉 Sistema em estado impecável!"
else
	echo "ℹ️ Diagnóstico concluído com ${_warn} observação(ões)."
fi
echo "================================"

exit 0
