#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: BastilleBSD Jail Automation Manager
# ----------------------------------------------------------------
set -eu

echo "📦 [Bastille]: Configurando gerenciador BastilleBSD..."

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

${ELEVATE} pkg install --yes sysutils/bastille
${ELEVATE} sysrc bastille_enable="YES"
${ELEVATE} service bastille start 2> "/dev/null" || true

echo "✅ [Bastille]: Gerenciador BastilleBSD pronto para uso!"
