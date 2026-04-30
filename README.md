# 💤 StayAwake

Eu uso o MuMu Player pra assistir coisas, e ele não avisa pro Windows que tem algo sendo assistido — então o monitor apagava do nada. A solução padrão seria entrar nas configurações de energia e mudar o tempo, mas aí você esquece de reverter e o monitor fica sem desligar.

Criei o StayAwake pra resolver isso de forma automática. Você configura uma vez quais apps quer monitorar, e a partir daí ele cuida do resto: quando o app abre, o Windows para de dormir. Quando fecha, tudo volta ao normal.

---

## ⚡ Como usar

1. Baixe e extraia o `StayAwake.zip`
2. Abra o `StayAwake.exe`
3. Adicione os apps que você quer monitorar
4. Pronto — pode fechar

Da próxima vez que abrir um dos apps configurados, o Windows para de desligar automaticamente. Quando você fechar o app, tudo volta ao normal.

---

## 🔔 Notificações

O StayAwake avisa quando ativa e quando desativa — aparece um balão no canto da tela com o nome do app e o tempo configurado.

---

## 📋 Requisitos

- Windows 10 ou 11
- [.NET 8 Runtime](https://dotnet.microsoft.com/download/dotnet/8.0) instalado
- Permissão de administrador na primeira vez que abrir
