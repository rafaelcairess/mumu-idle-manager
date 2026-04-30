# Idle Manager

> Ajusta o tempo de ociosidade do Windows automaticamente enquanto um aplicativo escolhido está aberto. Funciona com qualquer programa.

---

## O problema

Usar qualquer app com o Windows configurado para apagar o monitor em 10 minutos é irritante. Mudar nas configurações de energia toda vez é chato, e esquecer de reverter depois também.

## A solução

Dois executáveis simples — configure uma vez, use sempre:

| Arquivo | Quando usar |
|---|---|
| `Idle Config.exe` | Primeira vez ou quando quiser trocar de app |
| `Idle Manager.exe` | No dia a dia, no lugar do app diretamente |

---

## Como usar

**1. Configure uma vez:**

Abra `Idle Config.exe` → clique em `...` → selecione o `.exe` do app → ajuste os tempos → Salvar.

**2. Use sempre:**

Abra `Idle Manager.exe`. Ele lê a configuração, abre o app, ajusta o timeout e restaura ao fechar — tudo automático.

> O Windows pode pedir confirmação de administrador — necessário para alterar as configurações de energia.

---

## Funciona com qualquer app

Netflix, MuMu Player, emuladores, players de vídeo, qualquer `.exe`. Quer mudar de app? Abre o `Idle Config.exe` de novo e seleciona outro.

---

## Configuração

| Campo | Descrição | Padrão |
|---|---|---|
| Aplicativo | `.exe` do app a monitorar | — |
| Ociosidade durante o app | Tempo até o monitor apagar enquanto usa | 120 min |
| Ociosidade ao fechar | Tempo restaurado após fechar o app | 10 min |

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `Idle Manager.exe` | Launcher principal |
| `Idle Config.exe` | Configurador visual |
| `config.json` | Suas preferências salvas |
| `launcher.ps1` | Código-fonte do launcher |
| `config.ps1` | Código-fonte do configurador |

---

## Requisitos

- Windows 10 / 11
- PowerShell (já incluso no Windows)
