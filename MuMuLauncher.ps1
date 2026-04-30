# === CONFIGURACOES (padroes — sobrescritos por config.json se existir) ===
$IdleGame   = 120
$IdleNormal = 10
$AppExe     = ""

$configPath = "$PSScriptRoot\config.json"
if (Test-Path $configPath) {
    $cfg        = Get-Content $configPath | ConvertFrom-Json
    $IdleGame   = $cfg.IdleGame
    $IdleNormal = $cfg.IdleNormal
    $AppExe     = $cfg.AppExe
}

# === FUNCOES ===
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
if (-not $AppExe -or -not (Test-Path $AppExe)) {
    Show-Notification "Idle Manager" "Nenhum aplicativo configurado. Abra o Idle Config.exe primeiro."
    exit 1
}

$appName = Split-Path $AppExe -Leaf

Set-IdleTimeout $IdleGame
Show-Notification "Idle Manager" "$appName aberto — ociosidade: $IdleGame min"

Start-Process -FilePath $AppExe -PassThru | Wait-Process

Set-IdleTimeout $IdleNormal
Show-Notification "Idle Manager" "$appName fechado — ociosidade: $IdleNormal min restaurado"
