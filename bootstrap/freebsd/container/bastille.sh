#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: BastilleBSD Jail Automation Manager
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Bastille]: Configurando gerenciador BastilleBSD..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes bastille
${ELEVATE} sysrc bastille_enable="YES"
${ELEVATE} service bastille start 2> "/dev/null" || true

echo "✅ [Bastille]: Gerenciador BastilleBSD pronto para uso!"
