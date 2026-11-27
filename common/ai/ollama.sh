#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Ollama Inference Server & Python SDK
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

_setup_freebsd_logrotate() {
	if [ "$(uname -s)" = "FreeBSD" ]; then
		_ol_user="$(sysrc -n ollama_user 2> "/dev/null" || echo "nobody")"
		_ol_log="$(sysrc -n ollama_log 2> "/dev/null" || echo "/var/log/ollama-${_ol_user}.log")"
		[ -n "${_ol_user}" ] || _ol_user="nobody"
		[ -n "${_ol_log}" ] || _ol_log="/var/log/ollama-${_ol_user}.log"
		${ELEVATE} mkdir -p "/usr/local/etc/newsyslog.conf.d"
		printf "%s\t%s:wheel\t640\t5\t2048\t*\tJNC\n" "${_ol_log}" "${_ol_user}" | ${ELEVATE} tee "/usr/local/etc/newsyslog.conf.d/ollama.conf" > "/dev/null"
		${ELEVATE} chmod 0644 "/usr/local/etc/newsyslog.conf.d/ollama.conf"
	fi
}

if command -v ollama > "/dev/null" 2>&1; then
	_setup_freebsd_logrotate
	_ui_ok "Ollama já está instalado."
	exit 0
fi

_ui_step "Instalando Ollama e biblioteca Python..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes misc/ollama
	${ELEVATE} sysrc ollama_enable="YES" > "/dev/null" 2>&1 || true
	_setup_freebsd_logrotate
	${ELEVATE} service ollama start > "/dev/null" 2>&1 || true
	if command -v pip > "/dev/null" 2>&1; then
		pip install ollama > "/dev/null" 2>&1 || true
	fi
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes ollama python3-ollama
	command -v systemctl > "/dev/null" 2>&1 && ${ELEVATE} systemctl enable --now ollama 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	if ! command -v ollama > "/dev/null" 2>&1; then
		curl -fsSL https://ollama.com/install.sh | sh
	fi
	if command -v pip3 > "/dev/null" 2>&1; then
		pip3 install ollama > "/dev/null" 2>&1 || true
	elif command -v pip > "/dev/null" 2>&1; then
		pip install ollama > "/dev/null" 2>&1 || true
	fi
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		if command -v winget.exe > "/dev/null" 2>&1; then
			winget.exe install --id Ollama.Ollama --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
		fi
	else
		${ELEVATE} pacman -S --needed --noconfirm ollama
		command -v systemctl > "/dev/null" 2>&1 && ${ELEVATE} systemctl enable --now ollama 2> "/dev/null" || true
	fi
	if command -v pip > "/dev/null" 2>&1; then
		pip install ollama > "/dev/null" 2>&1 || true
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Ollama.Ollama --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	if command -v pip > "/dev/null" 2>&1; then
		pip install ollama > "/dev/null" 2>&1 || true
	fi
else
	_ui_err "Gerenciador de pacotes não suportado."
	exit 1
fi

_ui_ok "Ollama e SDK Python instalados com sucesso!"
