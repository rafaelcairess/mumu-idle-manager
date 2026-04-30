# === CONFIGURACOES (padroes — sobrescritos por config.json se existir) ===
$IdleGame   = 120
$IdleNormal = 10

$configPath = "$PSScriptRoot\config.json"
if (Test-Path $configPath) {
    $cfg        = Get-Content $configPath | ConvertFrom-Json
    $IdleGame   = $cfg.IdleGame
    $IdleNormal = $cfg.IdleNormal
}

# === FUNCOES ===
function Find-MuMuExe {
    $candidates = @(
        "D:\MuMuPlayerGlobal\nx_main\MuMuNxMain.exe",
        "D:\JOGOS\MuMuPlayerGlobal\nx_main\MuMuNxMain.exe",
        "C:\MuMuPlayerGlobal\nx_main\MuMuNxMain.exe",
        "$env:ProgramFiles\MuMuPlayer\nx_main\MuMuNxMain.exe",
        "$env:ProgramFiles\MuMuPlayerGlobal\nx_main\MuMuNxMain.exe"
    )
    foreach ($path in $candidates) {
        if (Test-Path $path) { return $path }
    }
    foreach ($root in (Get-PSDrive -PSProvider FileSystem).Root) {
        $found = Get-ChildItem -Path $root -Filter "MuMuNxMain.exe" -Recurse -ErrorAction SilentlyContinue -Force |
                 Select-Object -First 1
        if ($found) { return $found.FullName }
    }
    return $null
}

function Set-IdleTimeout($minutes) {
    powercfg /change monitor-timeout-ac $minutes
    powercfg /change standby-timeout-ac $minutes
}

function Show-Notification($title, $message) {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $notify         = New-Object System.Windows.Forms.NotifyIcon
    $icoPath        = "$PSScriptRoot\mumu.ico"
    if (Test-Path $icoPath) {
        $notify.Icon = New-Object System.Drawing.Icon($icoPath)
    } else {
        $notify.Icon = [System.Drawing.SystemIcons]::Information
    }
    $notify.Visible = $true
    $notify.ShowBalloonTip(4000, $title, $message, [System.Windows.Forms.ToolTipIcon]::None)
    Start-Sleep -Seconds 5
    $notify.Dispose()
}

# === MAIN ===
$MuMuExe = Find-MuMuExe

if (-not $MuMuExe) {
    Show-Notification "MuMu Player" "Instalacao nao encontrada no PC."
    exit 1
}

Set-IdleTimeout $IdleGame
Show-Notification "MuMu Player" "Ociosidade: $IdleGame min ativado"

Start-Process -FilePath $MuMuExe -PassThru | Wait-Process

Set-IdleTimeout $IdleNormal
Show-Notification "MuMu Player" "Ociosidade: $IdleNormal min restaurado"
