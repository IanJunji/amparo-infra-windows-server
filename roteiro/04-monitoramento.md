# 4. Monitoramento (alertas de CPU, disco e memória)

[Voltar ao README](../README.md)

Tudo no **Performance Monitor** (`perfmon.msc`).

## Criar o alerta

1. Data Collector Sets > **User Defined** > botão direito > New > Data Collector Set.
2. Nome `Amparo-Alertas`, opção **Create manually (Advanced)**.
3. Escolha **Performance Counter Alert**.
4. Adicione os três contadores com o limite:

| Contador | Alerta quando | Limite |
|---|---|---|
| `\Processor(_Total)\% Processor Time` | Above | 80 |
| `\LogicalDisk(C:)\% Free Space` | Below | 15 |
| `\Memory\Available MBytes` | Below | 500 |

5. Conclua o assistente.
6. Abra o conjunto `Amparo-Alertas`, botão direito no alerta (DataCollector01) > Properties:
   - aba **Alerts**: Sample interval de 15 segundos;
   - aba **Alert Action**: marque **Log an entry in the application event log**.
7. Botão direito em `Amparo-Alertas` > **Start**.

O conjunto não volta sozinho quando a VM reinicia. Antes de gravar o vídeo, confira se ele está como Running.

## Onde aparece o alerta

Event Viewer > Applications and Services Logs > Microsoft > Windows > **Diagnosis-PLA > Operational**, evento **2031**, com o contador e o valor que passou do limite.

## Testar o alerta de CPU

No PowerShell, deixe dois núcleos ocupados por um minuto e depois pare:

```powershell
1..2 | ForEach-Object { Start-Job { while ($true) {} } }
Start-Sleep -Seconds 60
Get-Job | Stop-Job; Get-Job | Remove-Job
```

Enquanto isso, mostre o gráfico em Monitoring Tools > Performance Monitor com o contador de CPU. Depois procure o evento 2031.
