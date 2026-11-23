#!/usr/bin/env sh
# ----------------------------------------------------------------
# Module: Universal Package Manager Operations
# ----------------------------------------------------------------
set -eu

if [ -z "${DETECTED_PKG_MGR:-}" ] && [ -n "${_setup_root:-}" ] && [ -f "${_setup_root}/core/detect.sh" ]; then
	. "${_setup_root}/core/detect.sh"
fi
if [ -z "${ELEVATE+x}" ] && [ -n "${_setup_root:-}" ] && [ -f "${_setup_root}/core/elevate.sh" ]; then
	. "${_setup_root}/core/elevate.sh"
fi

### ================================
### PACKAGE REPOSITORY UPDATE
### ================================
_pkg_update() {
	case "${DETECTED_PKG_MGR:-unknown}" in
		pkg)     ${ELEVATE:-} pkg update --quiet 2> "/dev/null" || ${ELEVATE:-} pkg update ;;
		dnf)     ${ELEVATE:-} dnf makecache --assumeyes 2> "/dev/null" || true ;;
		apt)     ${ELEVATE:-} apt-get update --quiet ;;
		pacman)
			if [ -n "${MSYSTEM:-}" ]; then
				pacman -Sy --noconfirm
			else
				${ELEVATE:-} pacman -Sy --noconfirm
			fi
			;;
		apk)     ${ELEVATE:-} apk update ;;
		zypper)  ${ELEVATE:-} zypper --non-interactive refresh ;;
		brew)    brew update ;;
		pkgin)   ${ELEVATE:-} pkgin -y update ;;
		xbps)    ${ELEVATE:-} xbps-install -S ;;
		pkg_add) return 0 ;;
		winget)  winget.exe source update ;;
		*)       return 1 ;;
	esac
}

### ================================
### PACKAGE INSTALLATION
### ================================
_pkg_install() {
	[ "$#" -gt 0 ] || return 0
	case "${DETECTED_PKG_MGR:-unknown}" in
		pkg)     ${ELEVATE:-} pkg install --yes "$@" ;;
		dnf)     ${ELEVATE:-} dnf install --assumeyes "$@" ;;
		apt)     ${ELEVATE:-} apt-get install --yes "$@" ;;
		pacman)
			if [ -n "${MSYSTEM:-}" ]; then
				pacman -S --needed --noconfirm "$@"
			else
				${ELEVATE:-} pacman -S --needed --noconfirm "$@"
			fi
			;;
		apk)     ${ELEVATE:-} apk add --no-cache "$@" ;;
		zypper)  ${ELEVATE:-} zypper --non-interactive install "$@" ;;
		brew)    brew install "$@" ;;
		pkg_add) ${ELEVATE:-} pkg_add "$@" ;;
		pkgin)   ${ELEVATE:-} pkgin -y install "$@" ;;
		xbps)    ${ELEVATE:-} xbps-install --yes "$@" ;;
		winget)
			for _pkg_id in "$@"; do
				winget.exe install --id "${_pkg_id}" --accept-package-agreements --accept-source-agreements
			done
			;;
		*)
			if command -v _ui_err > "/dev/null" 2>&1; then
				_ui_err "Gerenciador de pacotes não suportado: ${DETECTED_PKG_MGR:-unknown}"
			else
				echo "❌ Gerenciador de pacotes não suportado: ${DETECTED_PKG_MGR:-unknown}" >&2
			fi
			return 1
			;;
	esac
}
