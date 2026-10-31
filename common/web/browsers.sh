#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Common Web Browsers & Mail Client Suite
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." && pwd)"
. "${_setup_root}/core/ui.sh"
. "${_setup_root}/core/elevate.sh"

if command -v firefox > "/dev/null" 2>&1 && { command -v chromium > "/dev/null" 2>&1 || command -v chromium-browser > "/dev/null" 2>&1 || command -v google-chrome > "/dev/null" 2>&1 || command -v google-chrome-stable > "/dev/null" 2>&1; } && command -v thunderbird > "/dev/null" 2>&1; then
	_ui_ok "Navegadores e cliente de e-mail já instalados."
	exit 0
fi

_ui_step "Instalando Firefox, Chromium, Google Chrome e Thunderbird..."

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes www/firefox www/chromium mail/thunderbird
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes firefox chromium thunderbird 2> "/dev/null" || true
	${ELEVATE} dnf install --assumeyes google-chrome-stable 2> "/dev/null" || true
elif command -v apt > "/dev/null" 2>&1; then
	${ELEVATE} apt install --yes firefox chromium thunderbird 2> "/dev/null" || \
		${ELEVATE} apt install --yes firefox-esr chromium thunderbird 2> "/dev/null" || true
	${ELEVATE} apt install --yes google-chrome-stable 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	${ELEVATE} pacman --sync --needed --noconfirm firefox chromium thunderbird 2> "/dev/null" || true
	if command -v yay > "/dev/null" 2>&1; then
		yay --sync --needed --noconfirm google-chrome 2> "/dev/null" || true
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	winget.exe install --id Mozilla.Firefox.pt-BR --accept-package-agreements --accept-source-agreements 2> "/dev/null" || \
		winget.exe install --id Mozilla.Firefox.br --accept-package-agreements --accept-source-agreements 2> "/dev/null" || \
		winget.exe install --id Mozilla.Firefox --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id Google.Chrome --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id Hibbiki.Chromium --accept-package-agreements --accept-source-agreements 2> "/dev/null" || \
		winget.exe install --id eloston.ungoogled-chromium --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	winget.exe install --id Mozilla.Thunderbird.pt-BR --accept-package-agreements --accept-source-agreements 2> "/dev/null" || \
		winget.exe install --id Mozilla.Thunderbird.br --accept-package-agreements --accept-source-agreements 2> "/dev/null" || \
		winget.exe install --id Mozilla.Thunderbird --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
fi

_ui_ok "Navegadores e Thunderbird instalados com sucesso!"
