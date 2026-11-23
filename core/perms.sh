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
	for _entry in "${_root}/setup.sh" "${_root}/bootstrap.sh"; do
		[ -f "${_entry}" ] && chmod 0755 "${_entry}" 2> "/dev/null" || true
	done
	for _dir in "${_root}/core" "${_root}/hosts"; do
		if [ -d "${_dir}" ]; then
			for _f in "${_dir}"/*.sh; do
				[ -f "${_f}" ] && chmod 0755 "${_f}" 2> "/dev/null" || true
			done
		fi
	done
	if [ -d "${_root}/.scripts/audit" ]; then
		chmod 0755 "${_root}/.scripts/audit/"*.py 2> "/dev/null" || true
		chmod 0755 "${_root}/.scripts/audit/"*.sh 2> "/dev/null" || true
	fi
}
