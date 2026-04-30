# Idle Manager

> Ajusta o tempo de ociosidade do Windows automaticamente enquanto um aplicativo escolhido está aberto. Funciona com qualquer programa.

---

## O problema

Assistir ou usar qualquer app com o Windows configurado para apagar o monitor em 10 minutos é irritante. Mudar nas configurações de energia toda vez é chato, e esquecer de reverter depois também.

## A solução

Dois executáveis simples:

- **Idle Config.exe** — escolha o aplicativo e defina os tempos de ociosidade
- **Idle Manager.exe** — abre o app configurado, ajusta o timeout e restaura ao fechar

---

## Como usar

**1. Configure uma vez:**

Abra `Idle Config.exe`, selecione o `.exe` do app desejado e ajuste os tempos.

**2. Use sempre:**

Abra `Idle Manager.exe` no lugar do app diretamente. Ele cuida do resto.

> O Windows pode pedir confirmação de administrador — necessário para alterar as configurações de energia.

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `Idle Manager.exe` | Launcher principal — **abra este** |
| `Idle Config.exe` | Configurador — escolha o app e os tempos |
| `config.json` | Gerado pelo Config com suas preferências |
| `MuMuLauncher.ps1` | Código-fonte do launcher |
| `MuMuConfig.ps1` | Código-fonte do configurador |

---

## Configuração

Abra `Idle Config.exe` e defina:

- **Aplicativo** — qualquer `.exe` do seu PC
- **Ociosidade durante o app** — tempo até o monitor apagar enquanto usa (padrão: 120 min)
- **Ociosidade ao fechar** — tempo restaurado após fechar (padrão: 10 min)

---

## Requisitos

- Windows 10 / 11
- PowerShell (já incluso no Windows)
