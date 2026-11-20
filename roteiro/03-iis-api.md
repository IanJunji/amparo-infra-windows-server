# 3. IIS e publicação da API

[Voltar ao README](../README.md)

A aplicação é a API do Amparo (`backend-soa/`), em ASP.NET Core .NET 10 com banco SQLite.

## No computador de desenvolvimento

Na pasta `backend-soa`:

```powershell
dotnet publish src/Amparo.Api -c Release -o C:\deploy\publish

# cria o banco em src/Amparo.Api/App_Data/amparo.db
dotnet tool restore
dotnet ef database update --project src/Amparo.Api
```

Copie para a VM a pasta `C:\deploy\publish` e o arquivo `amparo.db`.

## Na VM

1. **Runtime.** Baixe o **ASP.NET Core Hosting Bundle 10** em <https://dotnet.microsoft.com/download/dotnet/10.0> e instale com duplo clique. Depois rode `iisreset`. O IIS já foi instalado no passo 1; se o Hosting Bundle for instalado antes do IIS, é preciso rodar o instalador de novo e escolher Repair.
2. **Arquivos.** Copie o conteúdo de `publish` para `C:\Amparo\api` e o `amparo.db` para `C:\Amparo\api\App_Data`.
3. Abra o **IIS Manager** (`inetmgr`).
4. **Default Web Site** > Stop.
5. **Application Pools** > Add Application Pool: nome `AmparoApiPool`, .NET CLR version **No Managed Code**. A identidade fica ApplicationPoolIdentity.
6. **Sites** > Add Website:
   - Site name: `Amparo`
   - Application pool: `AmparoApiPool`
   - Physical path: `C:\Amparo\api`
   - Binding: http, porta 80, Host name `api.amparo.local`
7. Site `Amparo` > **Logging** > Directory: `C:\Amparo\logs\iis`. Os logs ficam junto com os da API.
8. Site `Amparo` > **Bindings** > Add: https, porta 443, host `api.amparo.local`, com um certificado autoassinado (`New-SelfSignedCertificate -DnsName api.amparo.local -CertStoreLocation Cert:\LocalMachine\My`). O http 80 continua funcionando.
9. Site `Amparo` > **Authentication** > Anonymous Authentication > Edit > **Application pool identity**. Assim só a identidade do pool precisa de permissão na pasta.

## Permissão NTFS do pool

Em Properties > Security > Edit > Add, digite `IIS AppPool\AmparoApiPool` (em Locations, escolha o próprio servidor, não o domínio):

| Pasta | Permissão |
|---|---|
| `C:\Amparo` | Read & execute (só para o pool conseguir chegar até `api`) |
| `C:\Amparo\api` | Read & execute |
| `C:\Amparo\api\App_Data` | Modify (só o pool grava no banco) |
| `C:\Amparo\logs\api` | Modify |

## Testar

A API exige login. Na VM, abra `http://api.amparo.local/api/alertas` no navegador: a resposta é `401` com `{"mensagem":"Faça login para acessar esta rota."}`. Esse 401 vem da própria API, então ela subiu. Para ver os alertas, faça o login (está no [passo 7](07-validacao.md)).

O banco criado pelo `dotnet ef database update` já vem com dois usuários de teste fictícios: `operador` e `familia`.

**Chave do token.** Sem ela, a API sorteia uma chave nova a cada vez que o pool reinicia, e quem estava logado (a central, o app) tem que entrar de novo depois do teste de falha. Por isso a chave fica fixa numa variável de ambiente do pool, `Jwt__Chave`. Ela é sorteada dentro da VM e não aparece na tela:

```powershell
$bytes = New-Object byte[] 48
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$chave = [Convert]::ToBase64String($bytes)
& "$env:windir\System32\inetsrv\appcmd.exe" set config -section:system.applicationHost/applicationPools "/+[name='AmparoApiPool'].environmentVariables.[name='Jwt__Chave',value='$chave']" /commit:apphost
$chave = $null
Restart-WebAppPool AmparoApiPool
```

A chave fica só na configuração do IIS da VM, nunca no repositório. Como ela fica no pool e não no `web.config`, atualizar os arquivos da API não apaga a chave. Se o pool for recriado, rode esses comandos de novo.

No host, adicione ao arquivo `C:\Windows\System32\drivers\etc\hosts` (Bloco de Notas como Administrador):

```text
192.168.56.10  api.amparo.local
```

O serviço de ML não roda na VM. Sem ele a API usa a regra de limiar para confirmar a queda, então funciona do mesmo jeito.

## Se der erro

| Erro | O que fazer |
|---|---|
| HTTP 500.19 | Reparar o Hosting Bundle (foi instalado antes do IIS) e `iisreset` |
| HTTP 500.30 | A API não subiu: veja Event Viewer > Application, origem "IIS AspNetCore Module V2" |
| HTTP 500 só nas rotas do banco | Falta o `amparo.db` em App_Data ou a permissão Modify do pool |
| HTTP 404 pelo IP | O site só responde pelo nome `api.amparo.local` |
