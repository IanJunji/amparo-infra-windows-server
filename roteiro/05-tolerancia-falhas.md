# 5. Tolerância a falhas e teste de falha

[Voltar ao README](../README.md)

Se a API cai, a pulseira não consegue abrir o alerta de queda. Por isso o IIS e o pool precisam voltar sozinhos.

## Configurar

```powershell
.\03-recuperacao-automatica.ps1
```

O que o script faz e onde ver na interface:

| O quê | Configuração | Onde ver |
|---|---|---|
| Serviços W3SVC e WAS | Automatic; se o processo cair, reinicia em 5 s, 10 s e 30 s | `services.msc` > World Wide Web Publishing Service > aba **Recovery** |
| Pool `AmparoApiPool` | Start Mode AlwaysRunning, Idle Time-out 0, Ping ligado, Rapid-Fail Protection ligada | IIS Manager > Application Pools > AmparoApiPool > **Advanced Settings** |

Se o processo do pool (`w3wp.exe`) morrer, o IIS sobe outro sozinho. O ping faz o IIS trocar um processo travado.

## Teste de falha

```powershell
.\04-teste-falha.ps1
```

| Falha provocada | O que deve acontecer |
|---|---|
| Matar o `w3wp.exe` do AmparoApiPool | A API volta em poucos segundos |
| Matar o processo do serviço W3SVC | O Windows reinicia o serviço em cerca de 5 s (evento 7031 no log System) |

O script mostra o HTTP antes e depois de cada falha, os segundos até a API voltar e os eventos do log System. A saída fica em `C:\Amparo\evidencias\teste-falha-<data>.txt`; copie esse arquivo para a pasta `evidencias/` do repositório.

Não rode o teste muitas vezes seguidas: com 5 quedas em 5 minutos, a Rapid-Fail Protection desliga o pool. Se acontecer, clique em Start no pool pelo IIS Manager.
