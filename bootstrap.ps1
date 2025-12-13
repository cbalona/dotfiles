# Requires Run as Administrator
if (
    !(
        [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator"
    )
) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
}


Write-Host ">>> INITIALIZING SYSTEM OPTIMIZATION <<<" -ForegroundColor Cyan
# 2. Install software via Winget
try {
    winget source reset --force
    winget source update
}
catch {
    Write-Warning "Could not reset Winget sources. Continuing anyway..."
}

Write-Host "Installing Core Software..." -ForegroundColor Yellow
winget import -i "$PSScriptRoot\configs\install_list.json" --accept-package-agreements --accept-source-agreements

# 2. Enable WSL
Write-Host "Enabling WSL..." -ForegroundColor Yellow
wsl --install --no-distribution
wsl --install -d Debian

# 3. Execute Task Runner
Write-Host "Handing off to Task Runner..." -ForegroundColor Green
# Refresh env vars so 'task' command works immediately after install
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Set-Location $PSScriptRoot
task

# 4. Debloat
Write-Host "Debloating System..." -ForegroundColor Yellow
& ([scriptblock]::Create((Invoke-RestMethod "https://debloat.raphi.re/")))

Write-Host ">>> PROCESS COMPLETE. REBOOT RECOMMENDED. <<<" -ForegroundColor Cyan