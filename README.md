# MuMu Player Idle Manager

Nada demais — um script simples que ajusta o tempo de ociosidade do Windows automaticamente enquanto o MuMu Player está aberto.

## O que faz

- Ao abrir o MuMu Player: aumenta o timeout de ociosidade para **2 horas** (monitor e suspensão)
- Ao fechar o MuMu Player: restaura o timeout para **10 minutos**

Evita que o monitor apague ou o PC suspenda no meio de um jogo sem precisar mexer nas configurações de energia manualmente.

## Como usar

1. Abra `MuMu Player.lnk` (atalho na pasta ou na área de trabalho)
2. O MuMu Player inicia normalmente — o script roda em segundo plano sem janelas
3. Ao fechar o MuMu, tudo volta ao normal automaticamente

> O Windows pode pedir confirmação de administrador na primeira abertura — isso é necessário para que o script consiga alterar as configurações de energia.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `MuMuLauncher.ps1` | Script principal (lógica de ociosidade) |
| `MuMuLauncher.bat` | Invoca o PS1 sem abrir janela |
| `MuMu Player.lnk` | Atalho com ícone do MuMu — abra este |

## Configuração

Edite as variáveis no topo do `MuMuLauncher.ps1` para ajustar os tempos:

```powershell
$IdleGame   = 120  # minutos durante o jogo (padrão: 2 horas)
$IdleNormal = 10   # minutos fora do jogo  (padrão: 10 minutos)
```

## Requisitos

- Windows 10 / 11
- MuMu Player instalado em `D:\MuMuPlayerGlobal`
- PowerShell (já vem no Windows)
