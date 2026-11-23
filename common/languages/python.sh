#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Python Stack (TUI, GUI, Vision & Docs)
# ----------------------------------------------------------------
set -eu

_setup_root="$(cd "$(dirname "$0")/../.." 2> "/dev/null" && pwd || true)"
if [ -f "${_setup_root}/core/ui.sh" ] && [ -f "${_setup_root}/core/elevate.sh" ]; then
	. "${_setup_root}/core/ui.sh"
	. "${_setup_root}/core/elevate.sh"
else
	_ui_step() { printf "==> %s\n" "$*"; }
	_ui_sub()  { printf "  -> %s\n" "$*"; }
	_ui_ok()   { printf "  OK %s\n" "$*"; }
	_ui_err()  { printf "  FAIL %s\n" "$*" >&2; }
	ELEVATE=""
	if [ "$(id -u)" -ne 0 ]; then
		if command -v doas > "/dev/null" 2>&1; then
			ELEVATE="doas"
		elif command -v sudo > "/dev/null" 2>&1; then
			ELEVATE="sudo"
		fi
	fi
fi

### --------------------------------
### PYTHON RUNTIME RESOLUTION
### --------------------------------
_find_py() {
	for _cand in python3 python py.exe; do
		if command -v "${_cand}" > "/dev/null" 2>&1 && "${_cand}" -c "import sys" > "/dev/null" 2>&1; then
			printf "%s\n" "${_cand}"
			return 0
		fi
	done
	return 1
}

_py_bin="$(_find_py || true)"
if [ -n "${_py_bin}" ] && "${_py_bin}" -c "import PyQt6, rich, textual, cv2, numpy, PIL, docx, tqdm, ollama" > "/dev/null" 2>&1; then
	_ui_ok "Stack Python (PyQt6, Rich, Textual, OpenCV, NumPy, Pillow, python-docx, tqdm, Ollama) já instalada."
	exit 0
fi

_pip_sync_missing() {
	_py="$(_find_py || true)"
	[ -n "${_py}" ] || return 1
	_missing=""
	for _pair in \
		"PyQt6:PyQt6" "rich:rich" "textual:textual" \
		"cv2:opencv-python-headless" "numpy:numpy" \
		"PIL:Pillow" "docx:python-docx" "tqdm:tqdm" "ollama:ollama"; do
		_mod="${_pair%%:*}"
		_pkg="${_pair#*:}"
		if ! "${_py}" -c "import ${_mod}" > "/dev/null" 2>&1; then
			_missing="${_missing} ${_pkg}"
		fi
	done
	[ -z "${_missing}" ] && return 0
	_ui_sub "Sincronizando pacotes Python pendentes:${_missing}"
	# shellcheck disable=SC2086
	"${_py}" -m pip install --break-system-packages ${_missing} 2> "/dev/null" || \
		"${_py}" -m pip install --user --break-system-packages ${_missing} 2> "/dev/null" || \
		"${_py}" -m pip install --user ${_missing} 2> "/dev/null" || \
		"${_py}" -m pip install ${_missing} 2> "/dev/null" || \
		(command -v uv > "/dev/null" 2>&1 && uv pip install --system ${_missing} 2> "/dev/null") || true
}

_ui_step "Instalando stack Python (TUI, GUI, Visão Computacional & Documentos)..."

### --------------------------------
### PACKAGE MANAGER DISPATCH
### --------------------------------
if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		lang/python3 devel/py-pip devel/uv devel/py-qt6-pyqt \
		math/py-numpy graphics/py-pillow graphics/opencv textproc/py-rich misc/py-tqdm
	for _opt in graphics/py-opencv-python-headless textproc/py-textual textproc/py-python-docx misc/py-ollama; do
		${ELEVATE} pkg install --yes "${_opt}" 2> "/dev/null" || true
	done
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes \
		python3 python3-pip python3-pyqt6 python3-numpy \
		python3-pillow python3-opencv python3-rich python3-tqdm
	for _opt in uv python3-textual python3-docx python3-ollama; do
		${ELEVATE} dnf install --assumeyes "${_opt}" 2> "/dev/null" || true
	done
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		python3 python3-pip python3-venv python3-pyqt6 python3-numpy \
		python3-pil python3-opencv python3-rich python3-docx python3-tqdm
	for _opt in python3-textual python3-ollama; do
		${ELEVATE} apt-get install --yes "${_opt}" 2> "/dev/null" || true
	done
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-python mingw-w64-ucrt-x86_64-python-pip mingw-w64-ucrt-x86_64-uv \
			mingw-w64-ucrt-x86_64-python-pyqt6 mingw-w64-ucrt-x86_64-python-numpy mingw-w64-ucrt-x86_64-python-pillow \
			mingw-w64-ucrt-x86_64-opencv mingw-w64-ucrt-x86_64-python-opencv mingw-w64-ucrt-x86_64-python-rich \
			mingw-w64-ucrt-x86_64-python-docx mingw-w64-ucrt-x86_64-python-tqdm
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			python python-pip uv python-pyqt6 python-numpy \
			python-pillow python-opencv python-rich python-textual python-docx python-tqdm
	fi
elif command -v winget.exe > "/dev/null" 2>&1; then
	if [ -z "${_py_bin}" ]; then
		winget.exe install --id Python.Python.3.14 --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
	fi
	command -v uv > "/dev/null" 2>&1 || winget.exe install --id astral-sh.uv --accept-package-agreements --accept-source-agreements 2> "/dev/null" || true
elif [ -z "${_py_bin}" ]; then
	_ui_err "Gerenciador de pacotes compatível não encontrado."
	exit 1
fi

_pip_sync_missing
_ui_ok "Stack Python instalada com sucesso!"
