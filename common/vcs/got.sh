#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Game of Trees (Got) Configuration
# ----------------------------------------------------------------
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

if command -v got > "/dev/null" 2>&1; then
	echo "✅ [Got]: Binário 'got' disponível no PATH."
else
	echo "ℹ️  [Got]: Binário 'got' ainda não instalado (disponível via 'pkg install got' ou 'yay -S got-portable')."
fi
