Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$configPath = "$PSScriptRoot\config.json"
$defaults   = @{ AppExe = ""; IdleGame = 120; IdleNormal = 10 }

if (Test-Path $configPath) {
    $cfg = Get-Content $configPath | ConvertFrom-Json
} else {
    $cfg = [PSCustomObject]$defaults
}

# === FORM ===
$form                 = New-Object System.Windows.Forms.Form
$form.Text            = "Idle Manager — Configuracoes"
$form.Size            = New-Object System.Drawing.Size(420, 220)
$form.StartPosition   = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox     = $false
$form.MinimizeBox     = $false

if (Test-Path "$PSScriptRoot\mumu.ico") {
    $form.Icon = New-Object System.Drawing.Icon("$PSScriptRoot\mumu.ico")
}

# Selecionar aplicativo
$lblApp          = New-Object System.Windows.Forms.Label
$lblApp.Text     = "Aplicativo:"
$lblApp.Location = New-Object System.Drawing.Point(20, 20)
$lblApp.Size     = New-Object System.Drawing.Size(80, 20)

$txtApp          = New-Object System.Windows.Forms.TextBox
$txtApp.Location = New-Object System.Drawing.Point(100, 18)
$txtApp.Size     = New-Object System.Drawing.Size(220, 20)
$txtApp.Text     = $cfg.AppExe
$txtApp.ReadOnly = $true

$btnBrowse          = New-Object System.Windows.Forms.Button
$btnBrowse.Text     = "..."
$btnBrowse.Location = New-Object System.Drawing.Point(328, 16)
$btnBrowse.Size     = New-Object System.Drawing.Size(60, 24)
$btnBrowse.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "Executavel (*.exe)|*.exe"
    $dlg.Title  = "Selecione o aplicativo"
    if ($dlg.ShowDialog() -eq "OK") {
        $txtApp.Text = $dlg.FileName
    }
})

# Ociosidade durante o app
$lblGame          = New-Object System.Windows.Forms.Label
$lblGame.Text     = "Ociosidade durante o app (min):"
$lblGame.Location = New-Object System.Drawing.Point(20, 65)
$lblGame.Size     = New-Object System.Drawing.Size(230, 20)

$spinGame          = New-Object System.Windows.Forms.NumericUpDown
$spinGame.Location = New-Object System.Drawing.Point(255, 63)
$spinGame.Size     = New-Object System.Drawing.Size(55, 20)
$spinGame.Minimum  = 1
$spinGame.Maximum  = 480
$spinGame.Value    = $cfg.IdleGame

# Ociosidade ao fechar
$lblNormal          = New-Object System.Windows.Forms.Label
$lblNormal.Text     = "Ociosidade ao fechar o app (min):"
$lblNormal.Location = New-Object System.Drawing.Point(20, 105)
$lblNormal.Size     = New-Object System.Drawing.Size(230, 20)

$spinNormal          = New-Object System.Windows.Forms.NumericUpDown
$spinNormal.Location = New-Object System.Drawing.Point(255, 103)
$spinNormal.Size     = New-Object System.Drawing.Size(55, 20)
$spinNormal.Minimum  = 1
$spinNormal.Maximum  = 480
$spinNormal.Value    = $cfg.IdleNormal

# Botoes
$btnSave              = New-Object System.Windows.Forms.Button
$btnSave.Text         = "Salvar"
$btnSave.Location     = New-Object System.Drawing.Point(220, 148)
$btnSave.Size         = New-Object System.Drawing.Size(80, 28)
$btnSave.DialogResult = [System.Windows.Forms.DialogResult]::OK

$btnCancel              = New-Object System.Windows.Forms.Button
$btnCancel.Text         = "Cancelar"
$btnCancel.Location     = New-Object System.Drawing.Point(310, 148)
$btnCancel.Size         = New-Object System.Drawing.Size(80, 28)
$btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$form.Controls.AddRange(@($lblApp, $txtApp, $btnBrowse, $lblGame, $spinGame, $lblNormal, $spinNormal, $btnSave, $btnCancel))
$form.AcceptButton = $btnSave
$form.CancelButton = $btnCancel

if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    if (-not $txtApp.Text) {
        [System.Windows.Forms.MessageBox]::Show("Selecione um aplicativo antes de salvar.", "Idle Manager", "OK", "Warning")
    } else {
        @{ AppExe = $txtApp.Text; IdleGame = [int]$spinGame.Value; IdleNormal = [int]$spinNormal.Value } |
            ConvertTo-Json | Set-Content $configPath
        [System.Windows.Forms.MessageBox]::Show(
            "Configuracoes salvas!`nApp: $(Split-Path $txtApp.Text -Leaf)`nAtivo: $($spinGame.Value) min  |  Normal: $($spinNormal.Value) min",
            "Idle Manager", "OK", "Information"
        )
    }
}
