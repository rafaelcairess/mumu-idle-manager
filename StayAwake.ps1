Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$configPath  = "$PSScriptRoot\config.json"
$runningPath = "$PSScriptRoot\running.json"
$selfExe     = "$PSScriptRoot\StayAwake.exe"
$icoPath     = "$PSScriptRoot\stayawake.ico"
$IFEO_KEY    = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

# === HELPERS ===
function Load-Config {
    if (Test-Path $configPath) {
        return Get-Content $configPath | ConvertFrom-Json
    }
    return [PSCustomObject]@{ IdleGame = 120; IdleNormal = 10; Apps = @() }
}

function Save-Config($cfg) {
    $cfg | ConvertTo-Json -Depth 3 | Set-Content $configPath
}

function Set-IdleTimeout($minutes) {
    powercfg /change monitor-timeout-ac $minutes
    powercfg /change standby-timeout-ac $minutes
}

function Show-Notification($title, $message) {
    $notify         = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon    = if (Test-Path $icoPath) { New-Object System.Drawing.Icon($icoPath) } else { [System.Drawing.SystemIcons]::Information }
    $notify.Visible = $true
    $notify.ShowBalloonTip(4000, $title, $message, [System.Windows.Forms.ToolTipIcon]::None)
    Start-Sleep -Seconds 5
    $notify.Dispose()
}

function Get-RunningCount {
    if (Test-Path $runningPath) {
        return [int](Get-Content $runningPath | ConvertFrom-Json).Count
    }
    return 0
}

function Set-RunningCount($n) {
    [PSCustomObject]@{ Count = [Math]::Max(0, $n) } | ConvertTo-Json | Set-Content $runningPath
}

function Register-IFEO($exeName) {
    $key = "$IFEO_KEY\$exeName"
    if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
    Set-ItemProperty -Path $key -Name "Debugger" -Value "`"$selfExe`""
}

function Unregister-IFEO($exeName) {
    $key = "$IFEO_KEY\$exeName"
    if (Test-Path $key) { Remove-Item -Path $key -Recurse -Force }
}

# ============================================================
# MODO IFEO — chamado pelo Windows com o exe como argumento
# ============================================================
if ($args.Count -gt 0) {
    $AppExe  = $args[0]
    $appName = Split-Path $AppExe -Leaf
    $cfg     = Load-Config

    $count = Get-RunningCount
    Set-RunningCount ($count + 1)

    if ($count -eq 0) {
        Set-IdleTimeout $cfg.IdleGame
        Show-Notification "StayAwake" "$appName aberto — ociosidade: $($cfg.IdleGame) min"
    }

    $passArgs = $args | Select-Object -Skip 1
    if ($passArgs) {
        Start-Process -FilePath $AppExe -ArgumentList $passArgs -PassThru | Wait-Process
    } else {
        Start-Process -FilePath $AppExe -PassThru | Wait-Process
    }

    $count = Get-RunningCount
    Set-RunningCount ($count - 1)

    if ((Get-RunningCount) -eq 0) {
        Set-IdleTimeout $cfg.IdleNormal
        Show-Notification "StayAwake" "$appName fechado — ociosidade: $($cfg.IdleNormal) min restaurado"
        if (Test-Path $runningPath) { Remove-Item $runningPath -Force }
    }

    exit
}

# ============================================================
# MODO CONFIG — aberto diretamente pelo usuario
# ============================================================
$cfg = Load-Config

# --- FORM PRINCIPAL ---
$form                 = New-Object System.Windows.Forms.Form
$form.Text            = "StayAwake"
$form.Size            = New-Object System.Drawing.Size(420, 340)
$form.StartPosition   = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox     = $false
if (Test-Path $icoPath) { $form.Icon = New-Object System.Drawing.Icon($icoPath) }

# Lista de apps
$lblApps          = New-Object System.Windows.Forms.Label
$lblApps.Text     = "Apps monitorados:"
$lblApps.Location = New-Object System.Drawing.Point(20, 15)
$lblApps.Size     = New-Object System.Drawing.Size(200, 18)

$listBox          = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(20, 35)
$listBox.Size     = New-Object System.Drawing.Size(370, 120)
foreach ($app in $cfg.Apps) { $listBox.Items.Add($app) | Out-Null }

# Botoes adicionar / remover
$btnAdd          = New-Object System.Windows.Forms.Button
$btnAdd.Text     = "+ Adicionar app"
$btnAdd.Location = New-Object System.Drawing.Point(20, 165)
$btnAdd.Size     = New-Object System.Drawing.Size(120, 28)
$btnAdd.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "Executavel (*.exe)|*.exe"
    $dlg.Title  = "Selecione o aplicativo"
    if ($dlg.ShowDialog() -eq "OK") {
        $exeName = Split-Path $dlg.FileName -Leaf
        if ($listBox.Items -notcontains $exeName) {
            $listBox.Items.Add($exeName) | Out-Null
        }
    }
})

$btnRemove          = New-Object System.Windows.Forms.Button
$btnRemove.Text     = "Remover"
$btnRemove.Location = New-Object System.Drawing.Point(150, 165)
$btnRemove.Size     = New-Object System.Drawing.Size(80, 28)
$btnRemove.Add_Click({
    if ($listBox.SelectedItem) { $listBox.Items.Remove($listBox.SelectedItem) }
})

# Tempos
$lblGame          = New-Object System.Windows.Forms.Label
$lblGame.Text     = "Ociosidade durante o app (min):"
$lblGame.Location = New-Object System.Drawing.Point(20, 215)
$lblGame.Size     = New-Object System.Drawing.Size(230, 18)

$spinGame          = New-Object System.Windows.Forms.NumericUpDown
$spinGame.Location = New-Object System.Drawing.Point(255, 213)
$spinGame.Size     = New-Object System.Drawing.Size(55, 20)
$spinGame.Minimum  = 1; $spinGame.Maximum = 480
$spinGame.Value    = $cfg.IdleGame

$lblNormal          = New-Object System.Windows.Forms.Label
$lblNormal.Text     = "Ociosidade ao fechar o app (min):"
$lblNormal.Location = New-Object System.Drawing.Point(20, 250)
$lblNormal.Size     = New-Object System.Drawing.Size(230, 18)

$spinNormal          = New-Object System.Windows.Forms.NumericUpDown
$spinNormal.Location = New-Object System.Drawing.Point(255, 248)
$spinNormal.Size     = New-Object System.Drawing.Size(55, 20)
$spinNormal.Minimum  = 1; $spinNormal.Maximum = 480
$spinNormal.Value    = $cfg.IdleNormal

# Salvar / Cancelar
$btnSave              = New-Object System.Windows.Forms.Button
$btnSave.Text         = "Salvar"
$btnSave.Location     = New-Object System.Drawing.Point(225, 285)
$btnSave.Size         = New-Object System.Drawing.Size(80, 28)
$btnSave.DialogResult = [System.Windows.Forms.DialogResult]::OK

$btnCancel              = New-Object System.Windows.Forms.Button
$btnCancel.Text         = "Cancelar"
$btnCancel.Location     = New-Object System.Drawing.Point(315, 285)
$btnCancel.Size         = New-Object System.Drawing.Size(80, 28)
$btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$form.Controls.AddRange(@($lblApps, $listBox, $btnAdd, $btnRemove, $lblGame, $spinGame, $lblNormal, $spinNormal, $btnSave, $btnCancel))
$form.AcceptButton = $btnSave
$form.CancelButton = $btnCancel

if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $newApps = @($listBox.Items)

    # Registrar novos apps no IFEO
    foreach ($app in $newApps) {
        if ($cfg.Apps -notcontains $app) { Register-IFEO $app }
    }
    # Remover apps deletados do IFEO
    foreach ($app in $cfg.Apps) {
        if ($newApps -notcontains $app) { Unregister-IFEO $app }
    }

    $cfg.IdleGame   = [int]$spinGame.Value
    $cfg.IdleNormal = [int]$spinNormal.Value
    $cfg.Apps       = $newApps
    Save-Config $cfg

    [System.Windows.Forms.MessageBox]::Show(
        "Salvo! $($newApps.Count) app(s) monitorado(s).",
        "StayAwake", "OK", "Information"
    )
}
