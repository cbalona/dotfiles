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

function Get-TaskBinary {
    $UserPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Task.Task_Microsoft.Winget.Source_8wekyb3d8bbwe\task.exe"
    $GlobalPath = "C:\Program Files\Task\task.exe" # Common fallback
    
    if (Test-Path $UserPath) { return $UserPath }
    if (Test-Path $GlobalPath) { return $GlobalPath }
    return $null
}

$TaskExe = Get-TaskBinary

if ($TaskExe) {
    Write-Host "Task binary found at: $TaskExe" -ForegroundColor Gray
    Set-Location $PSScriptRoot
    & $TaskExe default
} else {
    # Fallback: Attempt a force-refresh of the environment for the current session only as a last resort
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    if (Get-Command task -ErrorAction SilentlyContinue) {
        task default
    } else {
        Write-Error "CRITICAL: 'task' binary not found. Please restart your terminal and run 'task' manually."
        exit 1
    }
}

# 4. Debloat
Write-Host "Debloating System..." -ForegroundColor Yellow
& ([scriptblock]::Create((Invoke-RestMethod "https://debloat.raphi.re/")))

Write-Host ">>> PROCESS COMPLETE. REBOOT RECOMMENDED. <<<" -ForegroundColor Cyan