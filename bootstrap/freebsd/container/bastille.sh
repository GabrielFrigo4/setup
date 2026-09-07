#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: BastilleBSD Jail Automation Manager
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Bastille]: Configurando gerenciador BastilleBSD..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes bastille
${ELEVATE} sysrc bastille_enable="YES"
${ELEVATE} service bastille start 2> "/dev/null" || true

echo "✅ [Bastille]: Gerenciador BastilleBSD pronto para uso!"
