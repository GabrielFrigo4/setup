#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Environment Workspace Provisioning
# ----------------------------------------------------------------
set -eu

echo "📦 [Workspace]: Provisionando o ecossistema Universal Environment..."

if [ -n "${1:-}" ]; then
	_env_dir="$1"
elif command -v xdg-user-dir > "/dev/null" 2>&1 && [ -n "$(xdg-user-dir DOCUMENTS 2> "/dev/null")" ]; then
	_env_dir="$(xdg-user-dir DOCUMENTS)/Environment"
elif [ -d "${HOME}/Documentos" ]; then
	_env_dir="${HOME}/Documentos/Environment"
elif [ -d "${HOME}/Documents" ]; then
	_env_dir="${HOME}/Documents/Environment"
else
	_env_dir="${HOME}/Documents/Environment"
fi

echo "  ↳ Diretório de destino: ${_env_dir}"

### --------------------------------
### Clonagem Hub e Submodulos
### --------------------------------
_hub_url="https://github.com/GabrielFrigo4/environment.git"

if [ ! -d "${_env_dir}/.git" ]; then
	echo "  ↳ Clonando repositório central Environment com submódulos..."
	git clone --recurse-submodules "${_hub_url}" "${_env_dir}"
else
	echo "  ℹ️ Environment já clonado. Sincronizando submódulos..."
	git -C "${_env_dir}" submodule update --init --recursive
fi

### --------------------------------
### Provisionamento do Vault
### --------------------------------
_vault_dir="${_env_dir}/Vault"
if [ ! -e "${_vault_dir}/.git" ]; then
	echo "🔐 Tentando clonar o Vault (repositório privado via SSH)..."
	if git clone "git@github.com:GabrielFrigo4/vault.git" "${_vault_dir}" 2> "/dev/null"; then
		echo "  ✅ Vault clonado com sucesso!"
	else
		echo "  ⚠️ Vault não clonado (acesso SSH restrito ou chave não configurada)."
	fi
else
	echo "  ℹ️ Vault já presente em ${_vault_dir}."
fi

### --------------------------------
### Ganchos e Estado Git
### --------------------------------
if [ -f "${_env_dir}/Makefile" ] && command -v make > "/dev/null" 2>&1; then
	echo "🪝 Configurando ganchos do ecossistema..."
	make -C "${_env_dir}" hooks > "/dev/null" 2>&1 || true
fi

echo "✅ [Workspace]: Ecossistema completo clonado e pronto em ${_env_dir}!"
echo "   Para operar o ambiente, acesse '${_env_dir}' e execute 'make help'."
exit 0
