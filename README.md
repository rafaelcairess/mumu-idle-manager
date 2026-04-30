# StayAwake

Cansado de o Windows apagar o monitor ou suspender o PC no meio do que você está assistindo ou fazendo? O StayAwake resolve isso — você configura uma vez e esquece.

Ele fica de olho nos apps que você escolheu. Quando um abre, o Windows para de dormir. Quando fecha, tudo volta ao normal automaticamente.

---

## Como funciona

O StayAwake usa um recurso nativo do Windows chamado IFEO *(Image File Execution Options)* para entrar junto com qualquer app que você configurar. Você continua abrindo seus apps do jeito que sempre abriu — ele só entra em cena quando precisa.

Nenhum processo fica rodando em background. O StayAwake só existe enquanto um dos seus apps estiver aberto.

---

## Primeiros passos

**1. Abra o `StayAwake.exe`**

A tela de configuração vai aparecer.

**2. Adicione seus apps**

Clique em `+ Adicionar app` e selecione o `.exe` de qualquer programa que você queira monitorar. Pode adicionar quantos quiser.

**3. Ajuste os tempos se quiser**

O padrão já funciona bem pra maioria dos casos:
- **Durante o app:** 120 minutos
- **Depois de fechar:** 10 minutos

**4. Salve e pronto**

A partir daí, abra seus apps normalmente. O StayAwake cuida do resto.

---

## Sem mistério

| Situação | O que acontece |
|---|---|
| Você abre um app monitorado | Timeout vira o que você configurou |
| Dois apps monitorados abertos | Timeout permanece estendido |
| Último app monitorado fecha | Timeout volta ao normal |
| Nenhum app monitorado aberto | StayAwake não está nem em memória |

---

## Requisitos

- Windows 10 ou 11
- Permissão de administrador na primeira configuração
