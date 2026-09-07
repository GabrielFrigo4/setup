# ------------------------------------------------------------------------------
# Tool: Line Endings Converter (PowerShell)
# ------------------------------------------------------------------------------
[CmdletBinding()]
param (
	[ValidateSet("ToUnix", "ToDos")]
	[string]$Mode = "ToUnix",
	[string]$Path = "."
)

$ErrorActionPreference = "Stop"

if ($Mode -eq "ToUnix") {
	Write-Host "📦 [Line Endings]: Convertendo arquivos para LF (UNIX)..."
	Get-ChildItem -Path $Path -Recurse -Include *.sh, *.ps1, *.lua, *.cmd, *.md, *.nu, *.json, *.toml, *.yaml -File | ForEach-Object {
		$content = [System.IO.File]::ReadAllText($_.FullName)
		if ($content.Contains("`r`n")) {
			$newContent = $content.Replace("`r`n", "`n")
			[System.IO.File]::WriteAllText($_.FullName, $newContent)
			Write-Host "  ➔ LF: $($_.Name)" -ForegroundColor Green
		}
	}
} else {
	Write-Host "📦 [Line Endings]: Convertendo arquivos para CRLF (Windows/DOS)..."
	Get-ChildItem -Path $Path -Recurse -Include *.cmd, *.reg -File | ForEach-Object {
		$content = [System.IO.File]::ReadAllText($_.FullName)
		if (-not $content.Contains("`r`n")) {
			$newContent = $content.Replace("`n", "`r`n")
			[System.IO.File]::WriteAllText($_.FullName, $newContent)
			Write-Host "  ➔ CRLF: $($_.Name)" -ForegroundColor Green
		}
	}
}

Write-Host "✅ [Line Endings]: Conversão concluída com sucesso!"
