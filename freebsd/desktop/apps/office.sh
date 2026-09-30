#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: FreeBSD Office Suites & Document Productivity
# ----------------------------------------------------------------
set -eu

echo "📦 [FreeBSD Office]: Provisionando suites de escritorio e produtividade..."

### --------------------------------
### Privilege Escalation
### --------------------------------
ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

### --------------------------------
### LibreOffice Native Suite
### --------------------------------
${ELEVATE} pkg install --yes editors/libreoffice

### --------------------------------
### Collabora Office Early Prep
### --------------------------------
if pkg search -q "^collabora-office$" > "/dev/null" 2>&1 || pkg search -q "^collabora$" > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes collabora-office
	echo "✅ [FreeBSD Office]: Collabora Office instalado com sucesso via pkg!"
else
	echo "ℹ️  [FreeBSD Office]: Collabora Office nativo ainda em desenvolvimento para FreeBSD."
	echo "↳ Suporte antecipado ativo; instalação automática quando o port for publicado."
fi

echo "✅ [FreeBSD Office]: Provisionamento de produtividade concluído!"
