# Idle Manager

> Ajusta o tempo de ociosidade do Windows automaticamente quando um app escolhido está aberto. Você abre o app normalmente — o Idle Manager entra junto e sai junto. Nada fica rodando em background.

---

## Como funciona

O Idle Manager usa um recurso nativo do Windows chamado **IFEO** para "entrar junto" com qualquer app configurado. Você continua abrindo o app da mesma forma que sempre abriu — o Idle Manager detecta isso e age automaticamente.

```
Você abre o app → Idle Manager ativa → ociosidade: 2h
Você fecha o app → Idle Manager encerra → ociosidade: 10min
```

Nada fica rodando quando nenhum app monitorado está aberto.

---

## Como usar

**1. Configure uma vez:**

Abra `IdleManager.exe` → clique em `+ Adicionar app` → selecione o `.exe` desejado → ajuste os tempos → Salvar.

**2. Use normalmente:**

Abra seu app do jeito que sempre abre. O Idle Manager cuida do resto automaticamente.

---

## Múltiplos apps

Você pode monitorar quantos apps quiser. Se dois estiverem abertos ao mesmo tempo, a ociosidade só é restaurada quando o **último** fechar.

---

## Configuração

| Campo | Descrição | Padrão |
|---|---|---|
| Apps monitorados | Lista de `.exe` a interceptar | — |
| Ociosidade durante o app | Timeout enquanto o app estiver aberto | 120 min |
| Ociosidade ao fechar | Timeout restaurado após fechar | 10 min |

---

## Arquivos

| Arquivo | Descrição |
|---|---|
| `IdleManager.exe` | Único executável — configurador + motor |
| `IdleManager.ps1` | Código-fonte |
| `config.json` | Configurações salvas |

---

## Requisitos

- Windows 10 / 11
- PowerShell (já incluso no Windows)
- Permissão de administrador (necessário para registrar os apps no sistema)
