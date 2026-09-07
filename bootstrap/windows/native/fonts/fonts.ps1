# ------------------------------------------------------------------------------
# Recipe: Windows System & Nerd Fonts Installation
# ------------------------------------------------------------------------------

$fonts = @("Carlito-Regular.ttf", "Carlito-Bold.ttf", "Carlito-Italic.ttf", "Carlito-BoldItalic.ttf")
$baseUrl = "https://github.com/google/fonts/raw/main/ofl/carlito/"
foreach ($font in $fonts) {
	Invoke-WebRequest -Uri "$baseUrl$font" -OutFile $font
	Install-Font -Path ".\$font"
	Remove-Item $font
}

if (Get-Command Install-NerdFont -ErrorAction SilentlyContinue) {
	Install-NerdFont -Name RobotoMono
	Install-NerdFont -Name JetBrainsMono
}

$mesloStyles = @("Regular", "Bold", "Italic", "Bold%20Italic")
foreach ($style in $mesloStyles) {
	$fileName = "MesloLGS NF " + ($style -replace "%20", " ") + ".ttf"
	Invoke-WebRequest -Uri "https://github.com/romkatv/powerlevel10k-media/raw/master/$fileName" -OutFile $fileName
	if (Get-Command Install-Font -ErrorAction SilentlyContinue) {
		Install-Font -Path ".\$fileName"
	}
	Remove-Item $fileName -ErrorAction SilentlyContinue
}

Write-Host "✅ Fontes instaladas com sucesso no Windows!"
