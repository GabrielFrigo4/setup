#!/usr/bin/env sh
# ----------------------------------------------------------------
# Module: Platform & Package Manager Detection
# ----------------------------------------------------------------
set -eu

### ================================
### OPERATING SYSTEM DETECTION
### ================================
_detect_os() {
	case "$(uname -s 2> "/dev/null" || echo "unknown")" in
		Linux*)                        echo "linux" ;;
		FreeBSD*)                      echo "freebsd" ;;
		OpenBSD*)                      echo "openbsd" ;;
		NetBSD*)                       echo "netbsd" ;;
		Darwin*)                       echo "macos" ;;
		MINGW*|CYGWIN*|MSYS*|Windows*) echo "windows" ;;
		*)                             echo "unknown" ;;
	esac
}

### ================================
### DISTRIBUTION DETECTION
### ================================
_detect_distro() {
	_os="$(_detect_os)"
	if [ "${_os}" = "linux" ]; then
		if [ -f "/etc/os-release" ]; then
			_distro_id="$(grep '^ID=' "/etc/os-release" 2> "/dev/null" | cut -d= -f2 | tr -d '"')"
			echo "${_distro_id:-generic}"
		elif [ -f "/etc/arch-release" ]; then
			echo "arch"
		elif [ -f "/etc/debian_version" ]; then
			echo "debian"
		elif [ -f "/etc/fedora-release" ]; then
			echo "fedora"
		elif [ -f "/etc/alpine-release" ]; then
			echo "alpine"
		elif [ -f "/etc/void-release" ]; then
			echo "void"
		else
			echo "generic"
		fi
	elif [ "${_os}" = "freebsd" ]; then
		echo "freebsd"
	elif [ "${_os}" = "windows" ]; then
		if [ -n "${MSYSTEM:-}" ]; then
			echo "msys2"
		else
			echo "windows"
		fi
	else
		echo "${_os}"
	fi
}

### ================================
### PACKAGE MANAGER DETECTION
### ================================
_detect_pkg_mgr() {
	if command -v pkg > "/dev/null" 2>&1; then
		echo "pkg"
	elif command -v dnf > "/dev/null" 2>&1; then
		echo "dnf"
	elif command -v apt-get > "/dev/null" 2>&1; then
		echo "apt"
	elif command -v pacman > "/dev/null" 2>&1; then
		echo "pacman"
	elif command -v apk > "/dev/null" 2>&1; then
		echo "apk"
	elif command -v xbps-install > "/dev/null" 2>&1; then
		echo "xbps"
	elif command -v winget.exe > "/dev/null" 2>&1 || command -v winget > "/dev/null" 2>&1; then
		echo "winget"
	else
		echo "unknown"
	fi
}

DETECTED_OS="$(_detect_os)"
DETECTED_DISTRO="$(_detect_distro)"
DETECTED_PKG_MGR="$(_detect_pkg_mgr)"
export DETECTED_OS DETECTED_DISTRO DETECTED_PKG_MGR
