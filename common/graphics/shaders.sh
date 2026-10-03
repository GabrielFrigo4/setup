#!/usr/bin/env sh
# ----------------------------------------------------------------
# Recipe: Universal Modern Shader Toolchains (Vulkan, Slang & DXC)
# ----------------------------------------------------------------
set -eu

echo "📦 [Shaders]: Detectando ecossistema e instalando Vulkan, Slang e DXC..."

ELEVATE="$( [ "$(id -u)" -ne 0 ] && { command -v doas > "/dev/null" 2>&1 && echo "doas" || { command -v sudo > "/dev/null" 2>&1 && echo "sudo"; }; } )"

if command -v pkg > "/dev/null" 2>&1; then
	${ELEVATE} pkg install --yes \
		vulkan-loader \
		vulkan-headers \
		vulkan-tools \
		shaderc \
		glslang \
		spirv-cross \
		spirv-tools
elif command -v dnf > "/dev/null" 2>&1; then
	${ELEVATE} dnf install --assumeyes --skip-unavailable \
		vulkan-loader-devel \
		vulkan-headers \
		vulkan-tools \
		glslang \
		spirv-tools \
		jq \
		unzip \
		curl \
		tar
	${ELEVATE} dnf copr enable --assumeyes rustyclanker/slang 2> "/dev/null" || true
	${ELEVATE} dnf install --assumeyes shader-slang 2> "/dev/null" || true
elif command -v apt-get > "/dev/null" 2>&1; then
	${ELEVATE} apt-get update -qq 2> "/dev/null" || true
	${ELEVATE} apt-get install --yes \
		libvulkan-dev \
		vulkan-tools \
		glslang-tools \
		libshaderc-dev \
		spirv-cross \
		spirv-tools \
		jq \
		unzip \
		curl \
		tar
	${ELEVATE} apt-get install --yes slang-compiler 2> "/dev/null" || true
elif command -v pacman > "/dev/null" 2>&1; then
	if [ -n "${MSYSTEM-}" ]; then
		pacman --needed --noconfirm -S \
			mingw-w64-ucrt-x86_64-vulkan-devel \
			mingw-w64-ucrt-x86_64-shaderc \
			mingw-w64-ucrt-x86_64-glslang \
			mingw-w64-ucrt-x86_64-spirv-cross \
			mingw-w64-ucrt-x86_64-spirv-tools \
			jq \
			unzip \
			curl \
			tar
	else
		${ELEVATE} pacman -S --needed --noconfirm \
			vulkan-icd-loader \
			vulkan-headers \
			vulkan-tools \
			shaderc \
			glslang \
			spirv-cross \
			spirv-tools \
			shader-slang \
			directx-shader-compiler \
			jq \
			unzip \
			curl \
			tar
	fi
fi

mkdir -p "${HOME}/.local/bin" "${HOME}/.local/opt/slang" "${HOME}/.local/opt/dxc"

if ! command -v slangc > "/dev/null" 2>&1 || ! command -v slangd > "/dev/null" 2>&1; then
	if [ ! -d "${HOME}/.local/opt/slang/bin" ]; then
		SLANG_URL="$(curl -s "https://api.github.com/repos/shader-slang/slang/releases/latest" \
			| jq -r '.assets[] | select(.name | test("linux-x86_64\\.zip$")) | .browser_download_url')"

		curl -L "${SLANG_URL}" -o "/tmp/slang-latest.zip"
		unzip -o "/tmp/slang-latest.zip" -d "${HOME}/.local/opt/slang"
		rm -f "/tmp/slang-latest.zip"
	fi

	for _bin in slangc slangd slang slangi; do
		if [ -f "${HOME}/.local/opt/slang/bin/${_bin}" ]; then
			chmod 0755 "${HOME}/.local/opt/slang/bin/${_bin}" 2> "/dev/null" || true
			if [ "$(uname -s)" = "FreeBSD" ]; then
				brandelf -t Linux "${HOME}/.local/opt/slang/bin/${_bin}" 2> "/dev/null" || true
			fi
			cat <<- WRAPPER > "${HOME}/.local/bin/${_bin}"
				#!/usr/bin/env sh
				export LD_LIBRARY_PATH="\$HOME/.local/opt/slang/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
				exec "\$HOME/.local/opt/slang/bin/${_bin}" "\$@"
			WRAPPER
			chmod 0755 "${HOME}/.local/bin/${_bin}"
		fi
	done
fi

if ! command -v dxc > "/dev/null" 2>&1 || ! command -v dxv > "/dev/null" 2>&1; then
	if [ ! -d "${HOME}/.local/opt/dxc/bin" ]; then
		if [ "$(uname -s)" = "FreeBSD" ]; then
			DXC_URL="$(curl -s "https://api.github.com/repos/microsoft/DirectXShaderCompiler/releases/tags/v1.8.2505.1" \
				| jq -r '.assets[] | select(.name | test("linux.*x86.*64.*\\.tar\\.gz$")) | .browser_download_url' | head -n 1)"
		else
			DXC_URL="$(curl -s "https://api.github.com/repos/microsoft/DirectXShaderCompiler/releases/latest" \
				| jq -r '.assets[] | select(.name | test("linux.*\\.tar\\.gz$")) | .browser_download_url' | head -n 1)"
		fi

		curl -L "${DXC_URL}" -o "/tmp/dxc.tar.gz"
		tar -xf "/tmp/dxc.tar.gz" -C "${HOME}/.local/opt/dxc"
		rm -f "/tmp/dxc.tar.gz"
	fi

	for _bin in dxc dxv; do
		if [ -f "${HOME}/.local/opt/dxc/bin/${_bin}" ]; then
			chmod 0755 "${HOME}/.local/opt/dxc/bin/${_bin}" 2> "/dev/null" || true
			if [ "$(uname -s)" = "FreeBSD" ]; then
				brandelf -t Linux "${HOME}/.local/opt/dxc/bin/${_bin}" 2> "/dev/null" || true
			fi
			cat <<- WRAPPER > "${HOME}/.local/bin/${_bin}"
				#!/usr/bin/env sh
				export LD_LIBRARY_PATH="\$HOME/.local/opt/dxc/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
				exec "\$HOME/.local/opt/dxc/bin/${_bin}" "\$@"
			WRAPPER
			chmod 0755 "${HOME}/.local/bin/${_bin}"
		fi
	done
fi

echo "✅ [Shaders]: Toolchains de shaders e Vulkan configuradas com sucesso!"
