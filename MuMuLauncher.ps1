# === CONFIGURACOES ===
$MuMuExe    = "D:\MuMuPlayerGlobal\nx_main\MuMuNxMain.exe"
$IdleGame   = 120  # minutos durante o jogo (2 horas)
$IdleNormal = 10   # minutos fora do jogo (10 minutos)

# === FUNCOES ===
function Set-IdleTimeout($minutes) {
    powercfg /change monitor-timeout-ac $minutes
    powercfg /change standby-timeout-ac $minutes
}

# === MAIN ===
Set-IdleTimeout $IdleGame
Start-Process -FilePath $MuMuExe -PassThru | Wait-Process
Set-IdleTimeout $IdleNormal
