Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$configPath = "$PSScriptRoot\config.json"
$defaults   = @{ IdleGame = 120; IdleNormal = 10 }

if (Test-Path $configPath) {
    $cfg = Get-Content $configPath | ConvertFrom-Json
} else {
    $cfg = [PSCustomObject]$defaults
}

# === FORM ===
$form                  = New-Object System.Windows.Forms.Form
$form.Text             = "MuMu Player — Configuracoes"
$form.Size             = New-Object System.Drawing.Size(320, 180)
$form.StartPosition    = "CenterScreen"
$form.FormBorderStyle  = "FixedDialog"
$form.MaximizeBox      = $false
$form.MinimizeBox      = $false

if (Test-Path "$PSScriptRoot\mumu.ico") {
    $form.Icon = New-Object System.Drawing.Icon("$PSScriptRoot\mumu.ico")
}

# Label + spinner — ociosidade durante o MuMu
$lblGame          = New-Object System.Windows.Forms.Label
$lblGame.Text     = "Ociosidade durante o MuMu (min):"
$lblGame.Location = New-Object System.Drawing.Point(20, 20)
$lblGame.Size     = New-Object System.Drawing.Size(230, 20)

$spinGame          = New-Object System.Windows.Forms.NumericUpDown
$spinGame.Location = New-Object System.Drawing.Point(255, 18)
$spinGame.Size     = New-Object System.Drawing.Size(45, 20)
$spinGame.Minimum  = 1
$spinGame.Maximum  = 480
$spinGame.Value    = $cfg.IdleGame

# Label + spinner — ociosidade ao fechar
$lblNormal          = New-Object System.Windows.Forms.Label
$lblNormal.Text     = "Ociosidade ao fechar o MuMu (min):"
$lblNormal.Location = New-Object System.Drawing.Point(20, 60)
$lblNormal.Size     = New-Object System.Drawing.Size(230, 20)

$spinNormal          = New-Object System.Windows.Forms.NumericUpDown
$spinNormal.Location = New-Object System.Drawing.Point(255, 58)
$spinNormal.Size     = New-Object System.Drawing.Size(45, 20)
$spinNormal.Minimum  = 1
$spinNormal.Maximum  = 480
$spinNormal.Value    = $cfg.IdleNormal

# Botoes
$btnSave             = New-Object System.Windows.Forms.Button
$btnSave.Text        = "Salvar"
$btnSave.Location    = New-Object System.Drawing.Point(130, 105)
$btnSave.Size        = New-Object System.Drawing.Size(75, 28)
$btnSave.DialogResult = [System.Windows.Forms.DialogResult]::OK

$btnCancel            = New-Object System.Windows.Forms.Button
$btnCancel.Text       = "Cancelar"
$btnCancel.Location   = New-Object System.Drawing.Point(215, 105)
$btnCancel.Size       = New-Object System.Drawing.Size(75, 28)
$btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$form.Controls.AddRange(@($lblGame, $spinGame, $lblNormal, $spinNormal, $btnSave, $btnCancel))
$form.AcceptButton = $btnSave
$form.CancelButton = $btnCancel

if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    @{ IdleGame = [int]$spinGame.Value; IdleNormal = [int]$spinNormal.Value } |
        ConvertTo-Json | Set-Content $configPath
    [System.Windows.Forms.MessageBox]::Show(
        "Configuracoes salvas!`nMuMu: $($spinGame.Value) min  |  Normal: $($spinNormal.Value) min",
        "MuMu Player", "OK", "Information"
    )
}
