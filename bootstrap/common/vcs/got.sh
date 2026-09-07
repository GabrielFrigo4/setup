#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Game of Trees (Got) Configuration
# ------------------------------------------------------------------------------
set -eu

echo "📦 [Got]: Configurando Game of Trees (Got)..."

GOT_CONF="${HOME}/.gotconfig"

if [ -n "${GIT_AUTHOR_NAME-}" ] && [ -n "${GIT_AUTHOR_EMAIL-}" ]; then
	cat <<- EOF > "${GOT_CONF}"
	author "${GIT_AUTHOR_NAME} <${GIT_AUTHOR_EMAIL}>"
	EOF
	chmod 0644 "${GOT_CONF}"
	echo "✅ [Got]: Arquivo ~/.gotconfig configurado com sucesso!"
else
	echo "⚠️  [Got]: Variáveis GIT_AUTHOR_NAME ou GIT_AUTHOR_EMAIL não definidas."
fi
