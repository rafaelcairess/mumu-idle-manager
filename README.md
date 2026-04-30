# MuMu Player — Idle Manager

> Script simples que ajusta o tempo de ociosidade do Windows automaticamente enquanto o MuMu Player está aberto. Nada demais, só uma conveniência.

---

## O problema

Assistir algo pelo MuMu Player com o Windows configurado para suspender ou apagar o monitor em 10 minutos de inatividade é irritante. Mudar nas configurações de energia toda vez é chato, e esquecer de reverter depois também.

## A solução

Um executável que você abre no lugar do MuMu Player. Ele:

- **Ao abrir:** define o timeout de ociosidade para o tempo configurado (padrão: 2 horas)
- **Enquanto roda:** aguarda o MuMu Player em segundo plano, sem janelas
- **Ao fechar o MuMu:** restaura o timeout automaticamente e envia uma notificação

---

## Como usar

1. Abra `MuMu Player.exe` (ou o atalho na área de trabalho)
2. Aceite a confirmação de administrador — necessário para alterar configurações de energia
3. O MuMu Player abre normalmente, o resto é automático

Para ajustar os tempos, abra `MuMu Config.exe`.

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `MuMu Player.exe` | Launcher principal — **abra este para assistir** |
| `MuMu Config.exe` | Janela de configuração dos tempos de ociosidade |
| `config.json` | Gerado pelo Config.exe com suas preferências |
| `MuMuLauncher.ps1` | Código-fonte do launcher |
| `MuMuConfig.ps1` | Código-fonte do configurador |
| `mumu.ico` | Ícone extraído do MuMu Player |

---

## Configuração

Abra `MuMu Config.exe` e ajuste:

- **Ociosidade durante o MuMu** — quanto tempo até o monitor apagar enquanto assiste (padrão: 120 min)
- **Ociosidade ao fechar** — tempo restaurado após fechar o MuMu (padrão: 10 min)

As configurações ficam salvas em `config.json` e são lidas automaticamente pelo launcher.

---

## Requisitos

- Windows 10 / 11
- MuMu Player (detectado automaticamente em qualquer caminho)
- PowerShell (já incluso no Windows)
