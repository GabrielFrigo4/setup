#!/usr/bin/env sh
# ----------------------------------------------------------------
# Module: Antifragile Privilege Elevation Resolver
# ----------------------------------------------------------------
set -eu

### ================================
### ELEVATION RESOLUTION
### ================================
ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi
export ELEVATE

_ensure_elevated() {
	if [ "$(id -u)" -ne 0 ] && [ -z "${ELEVATE}" ]; then
		if command -v _ui_err > "/dev/null" 2>&1; then
			_ui_err "Privilégios administrativos requeridos (sudo ou doas não encontrados)."
		else
			echo "❌ Privilégios administrativos requeridos (sudo ou doas não encontrados)." >&2
		fi
		return 1
	fi
	return 0
}
