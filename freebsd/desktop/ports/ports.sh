#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Ports Tree Management
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Ports]: Sincronizando árvore de Ports..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes git

PORTS_DIR="${PORTSDIR:-}"
if [ -z "${PORTS_DIR}" ]; then
	if [ -d "/usr/local/ports/.git" ] && [ ! -d "/usr/ports/.git" ]; then
		PORTS_DIR="/usr/local/ports"
	else
		PORTS_DIR="/usr/ports"
	fi
fi

PORTS_QUARTER="$(date +%Y)Q$(date +%m | awk '{print int(($1-1)/3)+1}')"
PORTS_TARGET="${1:-$PORTS_QUARTER}"

if [ ! -d "${PORTS_DIR}/.git" ]; then
	echo "   ➕ Clonando árvore de Ports inicial (${PORTS_TARGET})..."
	${ELEVATE} git clone --branch main --single-branch --depth 1 https://git.FreeBSD.org/ports.git "${PORTS_DIR}"
fi

${ELEVATE} git -C "${PORTS_DIR}" config --unset-all remote.origin.fetch 2> "/dev/null" || true
${ELEVATE} git -C "${PORTS_DIR}" config --add remote.origin.fetch "+refs/heads/main:refs/remotes/origin/main"
${ELEVATE} git -C "${PORTS_DIR}" config --add remote.origin.fetch "+refs/heads/${PORTS_QUARTER}:refs/remotes/origin/${PORTS_QUARTER}"

echo "   🔄 Buscando atualizações rasas (main e ${PORTS_QUARTER})..."
${ELEVATE} git -C "${PORTS_DIR}" fetch --depth 1 --prune origin

echo "   🔄 Sincronizando branch main..."
${ELEVATE} git -C "${PORTS_DIR}" checkout -B main origin/main > "/dev/null" 2>&1
${ELEVATE} git -C "${PORTS_DIR}" reset --hard origin/main > "/dev/null" 2>&1

echo "   🔄 Sincronizando branch trimestral corrente (${PORTS_QUARTER})..."
${ELEVATE} git -C "${PORTS_DIR}" checkout -B "${PORTS_QUARTER}" "origin/${PORTS_QUARTER}" > "/dev/null" 2>&1
${ELEVATE} git -C "${PORTS_DIR}" reset --hard "origin/${PORTS_QUARTER}" > "/dev/null" 2>&1

for _b in $(git -C "${PORTS_DIR}" for-each-ref --format='%(refname:short)' refs/heads/ 2> "/dev/null"); do
	case "${_b}" in
		[1-2][0-9][0-9][0-9]Q[1-4])
			if [ "${_b}" != "${PORTS_QUARTER}" ] && [ "${_b}" != "${PORTS_TARGET}" ]; then
				echo "   🗑️  Expurgando branch trimestral obsoleta: ${_b}..."
				${ELEVATE} git -C "${PORTS_DIR}" branch -D "${_b}" > "/dev/null" 2>&1 || true
			fi
			;;
	esac
done

if [ "${PORTS_TARGET}" = "main" ]; then
	${ELEVATE} git -C "${PORTS_DIR}" checkout main > "/dev/null" 2>&1
elif [ -n "${PORTS_TARGET}" ] && [ "${PORTS_TARGET}" != "${PORTS_QUARTER}" ]; then
	${ELEVATE} git -C "${PORTS_DIR}" checkout "${PORTS_TARGET}" > "/dev/null" 2>&1 || true
else
	${ELEVATE} git -C "${PORTS_DIR}" checkout "${PORTS_QUARTER}" > "/dev/null" 2>&1
fi

echo "✅ [FreeBSD Ports]: Árvore sincronizada com sucesso em ${PORTS_DIR}!"
