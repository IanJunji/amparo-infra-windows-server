# Roteiro do vídeo (até 7 minutos)

[Voltar ao README](README.md)

## Antes de gravar

- Conferir que o site, o pool e o conjunto `Amparo-Alertas` estão rodando.
- Errar a senha de `carla.mendes` uma vez, para ter o evento 4625.
- Rodar o teste de CPU uns minutos antes, para o evento do alerta já existir.
- Fechar notificações e janelas com senha. Fonte do PowerShell grande.

## Cenas

1. **Abertura (30 s):** quem somos e o problema do Amparo em uma frase.
2. **Rede e domínio (1 min):** `ipconfig /all`, `hostname`, Server Manager com as funções, usuários no AD, DNS com `api.amparo.local` e `nslookup`.
3. **IIS (1 min):** pool No Managed Code, site com o binding, `dotnet --list-runtimes`, permissão do pool em App_Data.
4. **GPO e acesso remoto (30 s):** GPO dos operadores e política de senha; conexão `mstsc` do host.
5. **Monitoramento (1 min):** alerta com CPU, disco e memória; gráfico de CPU; evento 2031.
6. **Teste de falha (1 min):** aba Recovery do serviço, Advanced Settings do pool e o `04-teste-falha.ps1` rodando, mostrando a API caindo e voltando.
7. **Auditoria (40 s):** `auditpol`, eventos 4625 e 4720, linhas do log do IIS.
8. **Funcionando (40 s):** do host, `curl` na API e um alerta novo aparecendo.

## Depois de gravar

- Conferir a duração.
- Subir no YouTube como não listado e colar o link no [README](README.md).
