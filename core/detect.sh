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
		DragonFly*)                    echo "dragonfly" ;;
		OpenBSD*)                      echo "openbsd" ;;
		NetBSD*)                       echo "netbsd" ;;
		SunOS*)                        echo "illumos" ;;
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
	elif [ "${_os}" = "freebsd" ] || [ "${_os}" = "dragonfly" ]; then
		echo "${_os}"
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
	_os="$(_detect_os)"
	case "${_os}" in
		freebsd|dragonfly)
			if command -v pkg > "/dev/null" 2>&1; then
				echo "pkg"
			else
				echo "unknown"
			fi
			;;
		openbsd)
			if command -v pkg_add > "/dev/null" 2>&1; then
				echo "pkg_add"
			else
				echo "unknown"
			fi
			;;
		netbsd)
			if command -v pkgin > "/dev/null" 2>&1; then
				echo "pkgin"
			else
				echo "unknown"
			fi
			;;
		illumos)
			if command -v pkg > "/dev/null" 2>&1; then
				echo "ips"
			elif command -v pkgin > "/dev/null" 2>&1; then
				echo "pkgin"
			else
				echo "unknown"
			fi
			;;
		macos)
			if command -v brew > "/dev/null" 2>&1; then
				echo "brew"
			else
				echo "unknown"
			fi
			;;
		windows)
			if command -v pacman > "/dev/null" 2>&1; then
				echo "pacman"
			elif command -v winget.exe > "/dev/null" 2>&1 || command -v winget > "/dev/null" 2>&1; then
				echo "winget"
			else
				echo "unknown"
			fi
			;;
		linux)
			if command -v dnf > "/dev/null" 2>&1; then
				echo "dnf"
			elif command -v apt-get > "/dev/null" 2>&1 || command -v apt > "/dev/null" 2>&1; then
				echo "apt"
			elif command -v pacman > "/dev/null" 2>&1; then
				echo "pacman"
			elif command -v zypper > "/dev/null" 2>&1; then
				echo "zypper"
			elif command -v apk > "/dev/null" 2>&1; then
				echo "apk"
			elif command -v xbps-install > "/dev/null" 2>&1; then
				echo "xbps"
			elif command -v tdnf > "/dev/null" 2>&1; then
				echo "tdnf"
			elif command -v emerge > "/dev/null" 2>&1; then
				echo "emerge"
			elif command -v nixos-rebuild > "/dev/null" 2>&1; then
				echo "nix"
			elif command -v eopkg > "/dev/null" 2>&1; then
				echo "eopkg"
			elif command -v guix > "/dev/null" 2>&1; then
				echo "guix"
			elif command -v opkg > "/dev/null" 2>&1; then
				echo "opkg"
			else
				echo "unknown"
			fi
			;;
		*)
			echo "unknown"
			;;
	esac
}

DETECTED_OS="$(_detect_os)"
DETECTED_DISTRO="$(_detect_distro)"
DETECTED_PKG_MGR="$(_detect_pkg_mgr)"
export DETECTED_OS DETECTED_DISTRO DETECTED_PKG_MGR
