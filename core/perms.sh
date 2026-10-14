#!/usr/bin/env sh
# ----------------------------------------------------------------
# Module: Repository Permissions and Self Healing
# ----------------------------------------------------------------
set -eu

### ================================
### PERMISSIONS SELF HEALING
### ================================
_self_heal_perms() {
	_root="${1:-.}"
	if [ -d "${_root}/.git" ] && command -v git > "/dev/null" 2>&1; then
		git -C "${_root}" config core.hooksPath .githooks 2> "/dev/null" || true
	fi
	if [ -d "${_root}/.githooks" ]; then
		chmod 0755 "${_root}/.githooks/"* 2> "/dev/null" || true
	fi
	if [ -f "${_root}/setup.sh" ]; then
		chmod 0755 "${_root}/setup.sh" 2> "/dev/null" || true
	fi
	if [ -d "${_root}/core" ]; then
		chmod 0755 "${_root}/core/"*.sh 2> "/dev/null" || true
	fi
	if [ -d "${_root}/.scripts/audit" ]; then
		chmod 0755 "${_root}/.scripts/audit/"*.py 2> "/dev/null" || true
		chmod 0755 "${_root}/.scripts/audit/"*.sh 2> "/dev/null" || true
	fi
}
