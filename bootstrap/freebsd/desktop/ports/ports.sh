#!/usr/bin/env sh
# ------------------------------------------------------------------------------
# Recipe: Ports Tree Management
# ------------------------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Ports]: Sincronizando árvore de Ports..."

if [ "$(id -u)" -ne 0 ] && command -v doas > "/dev/null" 2>&1; then
	ELEVATE="doas"
elif [ "$(id -u)" -ne 0 ] && command -v sudo > "/dev/null" 2>&1; then
	ELEVATE="sudo"
else
	ELEVATE=""
fi

${ELEVATE} pkg install --yes git

PORTS_QUARTER="$(date +%Y)Q$(date +%m | awk '{print int(($1-1)/3)+1}')"
PORTS_TARGET="${1:-$PORTS_QUARTER}"

if [ ! -d "/usr/ports/.git" ]; then
	echo "   ➕ Clonando árvore de Ports inicial (${PORTS_TARGET})..."
	${ELEVATE} git clone --branch main --single-branch --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
	${ELEVATE} git -C "/usr/ports" config --unset-all remote.origin.fetch
	${ELEVATE} git -C "/usr/ports" config --add remote.origin.fetch "+refs/heads/main:refs/remotes/origin/main"
	${ELEVATE} git -C "/usr/ports" config --add remote.origin.fetch "+refs/heads/${PORTS_QUARTER}:refs/remotes/origin/${PORTS_QUARTER}"
fi

echo "   🔄 Atualizando /usr/ports para ${PORTS_TARGET}..."
${ELEVATE} git -C "/usr/ports" fetch --depth 1
${ELEVATE} git -C "/usr/ports" checkout "${PORTS_TARGET}"
${ELEVATE} git -C "/usr/ports" reset --hard "origin/${PORTS_TARGET}"

echo "✅ [FreeBSD Ports]: Árvore sincronizada com sucesso em /usr/ports!"
