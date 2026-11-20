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
- [x] `4-alertas.jpg`: alerta Amparo-Alertas com CPU, disco e memória, em Running
- [x] `4-alertas.jpg` mostra o Status Running

**5. Tolerância a falhas**
- [x] `5-eventos-recuperacao.jpg`: eventos 7031 (o Windows reiniciou W3SVC e WAS em 5 s) e 5009 (pool caiu e voltou)
- [x] `5-teste-falha.jpg` mostra o pool com autoStart True e startMode AlwaysRunning
- [x] `5-teste-falha.jpg`: API voltou em 0 s (pool) e 4 s (serviço W3SVC); pool AlwaysRunning

**6. Auditoria e logs**
- [x] `6-auditpol.jpg`: auditoria de Logon, Account Lockout, File System e User Account Management + auditoria em App_Data
- [x] `6-eventos-seguranca.jpg`: eventos 4625, 4720 e 4663
- [x] `6-auditpol.jpg` mostra a auditoria de App_Data (Everyone: Delete, ChangePermissions, TakeOwnership)
- [x] `6-log-iis.jpg`: linhas do log do IIS (W3C) em C:\Amparo\logs\iis

**7. Validação**
- [x] `7-test-netconnection.jpg`: portas 80, 53, 389 e 3389 com True
- [x] `7-curl.jpg`: nslookup, login como operador e `/api/alertas` com token (HTTP 200)
