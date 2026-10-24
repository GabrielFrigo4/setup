#!/usr/bin/env sh
# ----------------------------------------------------------------
# Build: EWM (Emacs Wayland Manager) Native Rust Module
# ----------------------------------------------------------------
set -eu

_root="$(cd "$(dirname "$0")/../.." && pwd)"
sh "${_root}/common/editors/ewm.sh" "$@"
