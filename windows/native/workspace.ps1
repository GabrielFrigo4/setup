# ----------------------------------------------------------------
# Recipe: Windows Workspace & Hub Repositories Bootstrap
# ----------------------------------------------------------------
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

$WorkspaceDir = if ($env:WORKSPACE_DIR) { $env:WORKSPACE_DIR } else { Join-Path $env:USERPROFILE "Workspace" }
$HubRepos = @(
	@{ Name = "Environment"; Slug = "GabrielFrigo4/environment" },
	@{ Name = "Foundation";  Slug = "GabrielFrigo4/foundation" },
	@{ Name = "Personal";    Slug = "GabrielFrigo4/personal" },
	@{ Name = "Research";    Slug = "GabrielFrigo4/research" },
	@{ Name = "Training";    Slug = "GabrielFrigo4/training" },
	@{ Name = "Venture";     Slug = "GabrielFrigo4/venture" }
)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
	throw "git nao encontrado no PATH."
}

if (-not (Test-Path -Path $WorkspaceDir)) {
	New-Item -ItemType Directory -Path $WorkspaceDir -Force | Out-Null
}

$HasGh = $false
if (Get-Command gh -ErrorAction SilentlyContinue) {
	gh auth status *> $null
	if ($LASTEXITCODE -eq 0) { $HasGh = $true }
}

$MakeCmd = (Get-Command make -ErrorAction SilentlyContinue)?.Source
if (-not $MakeCmd -and (Test-Path "C:\msys64\usr\bin\make.exe")) {
	$MakeCmd = "C:\msys64\usr\bin\make.exe"
}

foreach ($Repo in $HubRepos) {
	$Dest = Join-Path $WorkspaceDir $Repo.Name
	if (Test-Path (Join-Path $Dest ".git")) {
		Write-Host "[v] $($Repo.Name): ja clonado em $Dest" -ForegroundColor Green
	} elseif ($HasGh) {
		gh repo clone $Repo.Slug $Dest
		if ($LASTEXITCODE -ne 0) { throw "Falha ao clonar $($Repo.Slug) via gh." }
		Write-Host "[v] $($Repo.Name): clonado via gh CLI" -ForegroundColor Green
	} else {
		git clone "https://github.com/$($Repo.Slug).git" $Dest
		if ($LASTEXITCODE -ne 0) { throw "Falha ao clonar $($Repo.Slug) via git." }
		Write-Host "[v] $($Repo.Name): clonado via git" -ForegroundColor Green
	}

	$MakefilePath = Join-Path $Dest "Makefile"
	if ((Test-Path $MakefilePath) -and (Select-String -Path $MakefilePath -Pattern '^\s*clone:' -Quiet)) {
		Push-Location $Dest
		try {
			if ($MakeCmd) {
				& $MakeCmd clone
			} else {
				git submodule update --init --recursive
			}
		} finally {
			Pop-Location
		}
	}
}

Write-Host "[v] Workspace configurado em $WorkspaceDir!" -ForegroundColor Green
