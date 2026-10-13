#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Ports Tree Management
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Ports]: Sincronizando árvore de Ports..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

${ELEVATE} pkg install --yes git

PORTS_QUARTER="$(date +%Y)Q$(date +%m | awk '{print int(($1-1)/3)+1}')"
PORTS_TARGET="${1:-$PORTS_QUARTER}"

if [ ! -d "/usr/ports/.git" ]; then
	echo "   ➕ Clonando árvore de Ports inicial (${PORTS_TARGET})..."
	${ELEVATE} git clone --branch main --single-branch --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
fi

${ELEVATE} git -C "/usr/ports" config --unset-all remote.origin.fetch 2> "/dev/null" || true
${ELEVATE} git -C "/usr/ports" config --add remote.origin.fetch "+refs/heads/main:refs/remotes/origin/main"
${ELEVATE} git -C "/usr/ports" config --add remote.origin.fetch "+refs/heads/${PORTS_QUARTER}:refs/remotes/origin/${PORTS_QUARTER}"

echo "   🔄 Buscando atualizações rasas (main e ${PORTS_QUARTER})..."
${ELEVATE} git -C "/usr/ports" fetch --depth 1 --prune origin

echo "   🔄 Sincronizando branch main..."
${ELEVATE} git -C "/usr/ports" checkout -B main origin/main > "/dev/null" 2>&1
${ELEVATE} git -C "/usr/ports" reset --hard origin/main > "/dev/null" 2>&1

echo "   🔄 Sincronizando branch trimestral corrente (${PORTS_QUARTER})..."
${ELEVATE} git -C "/usr/ports" checkout -B "${PORTS_QUARTER}" "origin/${PORTS_QUARTER}" > "/dev/null" 2>&1
${ELEVATE} git -C "/usr/ports" reset --hard "origin/${PORTS_QUARTER}" > "/dev/null" 2>&1

for _b in $(git -C "/usr/ports" for-each-ref --format='%(refname:short)' refs/heads/ 2> "/dev/null"); do
	case "${_b}" in
		[1-2][0-9][0-9][0-9]Q[1-4])
			if [ "${_b}" != "${PORTS_QUARTER}" ]; then
				echo "   🗑️  Expurgando branch trimestral obsoleta: ${_b}..."
				${ELEVATE} git -C "/usr/ports" branch -D "${_b}" > "/dev/null" 2>&1 || true
			fi
			;;
	esac
done

if [ "${PORTS_TARGET}" = "main" ]; then
	${ELEVATE} git -C "/usr/ports" checkout main > "/dev/null" 2>&1
else
	${ELEVATE} git -C "/usr/ports" checkout "${PORTS_QUARTER}" > "/dev/null" 2>&1
fi

echo "✅ [FreeBSD Ports]: Árvore sincronizada com sucesso em /usr/ports!"
