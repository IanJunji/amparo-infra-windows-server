# 7. Validação final

[Voltar ao README](../README.md)

Na VM:

```powershell
ipconfig /all
nslookup api.amparo.local
nslookup 192.168.56.10
Test-NetConnection api.amparo.local -Port 80
Test-NetConnection SRV-AMPARO01 -Port 53
Test-NetConnection SRV-AMPARO01 -Port 389
Test-NetConnection SRV-AMPARO01 -Port 3389
curl.exe -i http://api.amparo.local/api/alertas
```

Todos os `Test-NetConnection` devem mostrar `TcpTestSucceeded : True`. O `curl` sem login deve mostrar `HTTP/1.1 401 Unauthorized`: a API está no ar e protegendo a rota.

Agora com login, usando o usuário de teste fictício `operador` (senha `amparo123`, criada pela migration da API):

```powershell
$login = Invoke-RestMethod -Method Post http://api.amparo.local/api/auth/login -ContentType "application/json" -Body '{"usuario":"operador","senha":"amparo123"}'
Invoke-WebRequest http://api.amparo.local/api/alertas -UseBasicParsing -Headers @{ Authorization = "Bearer $($login.token)" } | Select-Object StatusCode, Content
```

Deve mostrar `StatusCode 200` e a lista de alertas em JSON.

No host (com a linha no arquivo `hosts`, ver [passo 3](03-iis-api.md)):

```powershell
Test-NetConnection api.amparo.local -Port 80
Test-NetConnection 192.168.56.10 -Port 53
Test-NetConnection 192.168.56.10 -Port 389
Test-NetConnection 192.168.56.10 -Port 3389
curl.exe -i http://api.amparo.local/api/alertas
```

Use o IP `192.168.56.10` (rede interna): pela placa NAT o firewall só deixa passar 80 e 443.

Por fim, mande uma leitura de teste ou o botão de pânico pela coleção do Insomnia em `backend-soa/insomnia/` e mostre o alerta aparecendo em `/api/alertas` (ou no app da central).
