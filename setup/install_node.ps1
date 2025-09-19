# install_node.ps1
# Usage (PowerShell):
#   Set-ExecutionPolicy Bypass -Scope Process -Force; `
#   & "PATH TO PROJECT/kioskbot_frontend\setup\install_node.ps1" `
#     "PATH TO PROJECT/kioskbot_frontend" -Reinstall

param(
  [Parameter(Mandatory = $true)][string]$ProjectDir,
  [switch]$Reinstall
)

if (-not (Test-Path -LiteralPath $ProjectDir)) {
  Write-Host "Project directory not found: $ProjectDir" -ForegroundColor Red
  exit 1
}

# Allow local scripts (pnpm.ps1/Corepack) for current user
try { Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -ErrorAction Stop } catch {}

# Ensure Chocolatey & NVS are present
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Host "Installing Chocolatey..." -ForegroundColor Cyan
  Set-ExecutionPolicy Bypass -Scope Process -Force
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Write-Host "Ensuring NVS is installed..." -ForegroundColor Cyan
choco install nvs -y --no-progress | Out-Null

# Put NVS first on PATH for *this session* (use string format to avoid quote issues)
$env:NVS_DIR = Join-Path $env:LOCALAPPDATA 'nvs'
$env:PATH = ("{0};{1}" -f $env:NVS_DIR, $env:PATH)

# Install/use/link Node 22.19.0 x64
nvs add 22.19.0/x64 | Out-Null
nvs use 22.19.0/x64 | Out-Null
nvs link 22.19.0/x64 | Out-Null

# Verify architecture
$arch = node -p "process.arch"
if ($arch -ne 'x64') {
  Write-Host "Node arch is $arch (expected x64). Aborting." -ForegroundColor Red
  exit 1
}
Write-Host ("Node {0} [{1}] at {2}" -f (node -v), $arch, (Get-Command node).Path) -ForegroundColor Green

# Enable Corepack and pin pnpm
corepack enable
corepack use pnpm@10.16.1
