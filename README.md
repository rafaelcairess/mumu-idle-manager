# MuMu Player — Idle Manager

> Script simples que ajusta o tempo de ociosidade do Windows automaticamente enquanto o MuMu Player está aberto. Nada demais, só uma conveniência.

---

## O problema

Assistir algo pelo MuMu Player com o Windows configurado para suspender ou apagar o monitor em 10 minutos de inatividade é irritante. Mudar nas configurações de energia toda vez é chato, e esquecer de reverter depois também.

## A solução

Um executável que você abre no lugar do MuMu Player. Ele:

- **Ao abrir:** define o timeout de ociosidade para **2 horas**
- **Enquanto roda:** aguarda o MuMu Player em segundo plano (sem janelas)
- **Ao fechar o MuMu:** restaura o timeout para **10 minutos** e encerra

---

## Como usar

1. Abra `MuMu Player.exe` (ou o atalho na área de trabalho)
2. Aceite a confirmação de administrador — necessário para alterar configurações de energia
3. O MuMu Player abre normalmente, o resto é automático

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `MuMu Player.exe` | Executável final — **abra este** |
| `MuMuLauncher.ps1` | Script fonte com a lógica |
| `MuMuLauncher.bat` | Invoca o PS1 sem janela (usado internamente) |
| `mumu.ico` | Ícone extraído do MuMu Player |

---

## Configuração

Para ajustar os tempos, edite as variáveis no topo do `MuMuLauncher.ps1` e regenere o `.exe`:

```powershell
$IdleGame   = 120  # minutos enquanto assiste  (padrão: 2 horas)
$IdleNormal = 10   # minutos fora do MuMu      (padrão: 10 minutos)
```

Para regenerar o `.exe` após editar o `.ps1`:

```powershell
Import-Module ps2exe
Invoke-ps2exe -InputFile "MuMuLauncher.ps1" -OutputFile "MuMu Player.exe" -IconFile "mumu.ico" -NoConsole -RequireAdmin
```

---

## Requisitos

- Windows 10 / 11
- MuMu Player instalado em `D:\MuMuPlayerGlobal`
- PowerShell (já incluso no Windows)
