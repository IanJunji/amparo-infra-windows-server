# Evidências

[Voltar ao README](../README.md)

Coloque os prints nesta pasta com os nomes abaixo e marque quando estiver pronto. Não deixe senha aparecendo em nenhum print.

**1. Rede e domínio**
- [x] `1-ipconfig.png`: `ipconfig /all` com 192.168.56.10 fixo
- [x] `1-hostname.png`: `hostname` = SRV-AMPARO01
- [x] `1-server-manager.png`: Server Manager com AD DS, DNS, File Server e IIS
- [x] `1-ad-usuarios.png`: OU Amparo com usuários e grupos
- [x] `1-dns.png`: zona amparo.local com o registro `api`
- [x] `1-nslookup.png`: `nslookup api.amparo.local` e `nslookup 192.168.56.10`

**2. Pastas, GPO e acesso remoto**
- [x] `2-ntfs-amparo.png`: segurança de C:\Amparo sem herança
- [x] `2-compartilhamento.png`: compartilhamento AmparoRelatorios
- [x] `2-gpo-senha.png`: política de senha e bloqueio
- [x] `2-gpo-operadores.png`: GPO-Amparo-Operadores ligada na OU Operadores
- [x] `2-rdp.png`: conexão `mstsc` do host como AMPARO\adm.rafael

**3. IIS e API**
- [x] `3-pool.png`: AmparoApiPool com No Managed Code
- [x] `3-site.png`: site Amparo com o binding `api.amparo.local`
- [x] `3-dotnet.png`: `dotnet --list-runtimes` com Microsoft.AspNetCore.App 10
- [x] `3-ntfs-app-data.png`: App_Data com o pool em Modify
- [x] `3-api-navegador.png`: `/api/alertas` aberto no navegador (versão antes do login; com login a resposta é 401)

**4. Monitoramento**
- [ ] `4-alertas.png`: propriedades do alerta com CPU, disco e memória
- [ ] `4-running.png`: Amparo-Alertas em Running
- [ ] `4-evento-alerta.png`: evento 2031 depois do teste de CPU

**5. Tolerância a falhas**
- [ ] `5-recovery.png`: aba Recovery do serviço ou `sc.exe qfailure W3SVC`
- [ ] `5-pool-avancado.png`: Advanced Settings do pool
- [ ] `5-teste-falha.png`: tela do teste com os segundos até voltar
- [ ] `teste-falha-AAAAMMDD-HHMM.txt`: saída completa do teste

**6. Auditoria e logs**
- [ ] `6-auditpol.png`: `auditpol /get /category:*`
- [ ] `6-eventos-seguranca.png`: eventos 4625, 4720 e 4663
- [ ] `6-auditoria-app-data.png`: aba Auditing de App_Data
- [ ] `6-log-iis.png`: linhas do log do IIS com 200 e 404

**7. Validação**
- [ ] `7-test-netconnection.png`: portas 80, 53, 389 e 3389 com True
- [ ] `7-curl.png`: `curl.exe -i` sem login (401) e o login + `/api/alertas` com token (200)
- [ ] `7-host.png`: API acessada a partir do host
